require "helper"

class TestRelatedPosts < BuntoUnitTest
  context "building related posts without lsi" do
    setup do
      @site = fixture_site
    end

    should "use the most recent posts for related posts" do
      @site.reset
      @site.read

      last_post     = @site.posts.last
      related_posts = Bunto::RelatedPosts.new(last_post).build

      last_ten_recent_posts = (@site.posts.docs.reverse - [last_post]).first(10)
      assert_equal last_ten_recent_posts, related_posts
    end
  end

  context "building related posts with LSI" do
    setup do
      if jruby?
        skip(
          "JRuby does not perform well with CExt, test disabled."
        )
      end

      allow_any_instance_of(Bunto::RelatedPosts).to receive(:display)
      @site = fixture_site({
        "lsi" => true,
      })

      @site.reset
      @site.read
      require "classifier-reborn"
      Bunto::RelatedPosts.lsi = nil
    end

    should "index Bunto::Post objects" do
      @site.posts.docs = @site.posts.docs.first(1)
      expect_any_instance_of(::ClassifierReborn::LSI).to \
        receive(:add_item).with(kind_of(Bunto::Document))
      Bunto::RelatedPosts.new(@site.posts.last).build_index
    end

    should "find related Bunto::Post objects, given a Bunto::Post object" do
      post = @site.posts.last
      allow_any_instance_of(::ClassifierReborn::LSI).to receive(:build_index)
      expect_any_instance_of(::ClassifierReborn::LSI).to \
        receive(:find_related).with(post, 11).and_return(@site.posts[-1..-9])

      Bunto::RelatedPosts.new(post).build
    end

    should "use LSI for the related posts" do
      allow_any_instance_of(::ClassifierReborn::LSI).to \
        receive(:find_related).and_return(@site.posts[-1..-9])
      allow_any_instance_of(::ClassifierReborn::LSI).to receive(:build_index)

      assert_equal @site.posts[-1..-9], Bunto::RelatedPosts.new(@site.posts.last).build
    end
  end
end
