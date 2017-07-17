require "helper"

class TestPluginManager < BuntoUnitTest
  def with_no_gemfile
    FileUtils.mv "Gemfile", "Gemfile.old"
    yield
  ensure
    FileUtils.mv "Gemfile.old", "Gemfile"
  end

  context "BUNTO_NO_BUNDLER_REQUIRE set to `nil`" do
    should "require from bundler" do
      with_env("BUNTO_NO_BUNDLER_REQUIRE", nil) do
        assert Bunto::PluginManager.require_from_bundler,
               "require_from_bundler should return true."
        assert ENV["BUNTO_NO_BUNDLER_REQUIRE"], "Gemfile plugins were not required."
      end
    end
  end

  context "BUNTO_NO_BUNDLER_REQUIRE set to `true`" do
    should "not require from bundler" do
      with_env("BUNTO_NO_BUNDLER_REQUIRE", "true") do
        refute Bunto::PluginManager.require_from_bundler,
                     "Gemfile plugins were required but shouldn't have been"
        assert ENV["BUNTO_NO_BUNDLER_REQUIRE"]
      end
    end
  end

  context "BUNTO_NO_BUNDLER_REQUIRE set to `nil` and no Gemfile present" do
    should "not require from bundler" do
      with_env("BUNTO_NO_BUNDLER_REQUIRE", nil) do
        with_no_gemfile do
          refute Bunto::PluginManager.require_from_bundler,
                       "Gemfile plugins were required but shouldn't have been"
          assert_nil ENV["BUNTO_NO_BUNDLER_REQUIRE"]
        end
      end
    end
  end

  context "require gems" do
    should "invoke `require_with_graceful_fail`" do
      gems = %w(jemojii foobar)

      expect(Bunto::External).to(
        receive(:require_with_graceful_fail).with(gems).and_return(nil)
      )
      site = double(:gems => gems)
      plugin_manager = PluginManager.new(site)

      allow(plugin_manager).to receive(:plugin_allowed?).with("foobar").and_return(true)
      allow(plugin_manager).to receive(:plugin_allowed?).with("jemojii").and_return(true)

      plugin_manager.require_gems
    end
  end

  context "site is not marked as safe" do
    should "allow all plugins" do
      site = double(:safe => false)
      plugin_manager = PluginManager.new(site)

      assert plugin_manager.plugin_allowed?("foobar")
    end

    should "require plugin files" do
      site = double({ :safe          => false,
                      :config        => { "plugins_dir" => "_plugins" },
                      :in_source_dir => "/tmp/", })
      plugin_manager = PluginManager.new(site)

      expect(Bunto::External).to receive(:require_with_graceful_fail)
      plugin_manager.require_plugin_files
    end
  end

  context "site is marked as safe" do
    should "allow plugins if they are whitelisted" do
      site = double({ :safe => true, :config => { "whitelist" => ["jemoji"] } })
      plugin_manager = PluginManager.new(site)

      assert plugin_manager.plugin_allowed?("jemoji")
      assert !plugin_manager.plugin_allowed?("not_allowed_plugin")
    end

    should "not require plugin files" do
      site = double({ :safe => true })
      plugin_manager = PluginManager.new(site)

      expect(Bunto::External).to_not receive(:require_with_graceful_fail)
      plugin_manager.require_plugin_files
    end
  end

  context "plugins_dir is set to the default" do
    should "call site's in_source_dir" do
      site = double({
        :config        => {
          "plugins_dir" => Bunto::Configuration::DEFAULTS["plugins_dir"],
        },
        :in_source_dir => "/tmp/",
      })
      plugin_manager = PluginManager.new(site)

      expect(site).to receive(:in_source_dir).with("_plugins")
      plugin_manager.plugins_path
    end
  end

  context "plugins_dir is set to a different dir" do
    should "expand plugin path" do
      site = double({ :config => { "plugins_dir" => "some_other_plugins_path" } })
      plugin_manager = PluginManager.new(site)

      expect(File).to receive(:expand_path).with("some_other_plugins_path")
      plugin_manager.plugins_path
    end
  end

  context "`paginate` config is activated" do
    should "print deprecation warning if bunto-paginate is not present" do
      site = double({ :config => { "paginate" => true } })
      plugin_manager = PluginManager.new(site)

      expect(Bunto::Deprecator).to(
        receive(:deprecation_message).with(%r!bunto-paginate!)
      )
      plugin_manager.deprecation_checks
    end

    should "print no deprecation warning if bunto-paginate is present" do
      site = double({
        :config => { "paginate" => true, "gems" => ["bunto-paginate"] },
      })
      plugin_manager = PluginManager.new(site)

      expect(Bunto::Deprecator).to_not receive(:deprecation_message)
      plugin_manager.deprecation_checks
    end
  end

  should "conscientious require" do
    site = double
    plugin_manager = PluginManager.new(site)

    expect(plugin_manager).to(
      receive_messages([:require_plugin_files, :require_gems, :deprecation_checks])
    )
    plugin_manager.conscientious_require
  end
end
