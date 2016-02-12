---
layout: docs
title: Plugins
permalink: /docs/plugins/
---

Bunto has a plugin system with hooks that allow you to create custom generated
content specific to your site. You can run custom code for your site without
having to modify the Bunto source itself.

<div class="note info">
  <h5>Plugins on GitHub Pages</h5>
  <p>
    <a href="http://pages.github.com/">GitHub Pages</a> is powered by Bunto.
    However, all Pages sites are generated using the <code>--safe</code> option
    to disable custom plugins for security reasons. Unfortunately, this means
    your plugins won’t work if you’re deploying to GitHub Pages.<br><br>
    You can still use GitHub Pages to publish your site, but you’ll need to
    convert the site locally and push the generated static files to your GitHub
    repository instead of the Bunto source files.
  </p>
</div>

## Installing a plugin

You have 3 options for installing plugins:

1. In your site source root, make a `_plugins` directory. Place your plugins
here. Any file ending in `*.rb` inside this directory will be loaded before
Bunto generates your site.
2. In your `_config.yml` file, add a new array with the key `gems` and the
values of the gem names of the plugins you'd like to use. An example:


        gems: [bunto-coffeescript, bunto-watch, bunto-assets]
        # This will require each of these gems automatically.

    Then install your plugins using `gem install bunto-coffeescript bunto-watch bunto-assets`

3. Add the relevant plugins to a Bundler group in your `Gemfile`. An
    example:

        group :bunto_plugins do
          gem "my-bunto-plugin"
          gem "another-bunto-plugin"
        end

    Now you need to install all plugins from your Bundler group by running single command `bundle install`


<div class="note info">
  <h5>
    <code>_plugins</code>, <code>_config.yml</code> and <code>Gemfile</code>
    can be used simultaneously
  </h5>
  <p>
    You may use any of the aforementioned plugin options simultaneously in the
    same site if you so choose. Use of one does not restrict the use of the
    others.
  </p>
</div>

In general, plugins you make will fall into one of four categories:

1. [Generators](#generators)
2. [Converters](#converters)
3. [Commands](#commands)
4. [Tags](#tags)

## Generators

You can create a generator when you need Bunto to create additional content
based on your own rules.

A generator is a subclass of `Bunto::Generator` that defines a `generate`
method, which receives an instance of
[`Bunto::Site`]({{ site.repository }}/blob/master/lib/bunto/site.rb). The
return value of `generate` is ignored.

Generators run after Bunto has made an inventory of the existing content, and
before the site is generated. Pages with YAML Front Matters are stored as
instances of
[`Bunto::Page`]({{ site.repository }}/blob/master/lib/bunto/page.rb)
and are available via `site.pages`. Static files become instances of
[`Bunto::StaticFile`]({{ site.repository }}/blob/master/lib/bunto/static_file.rb)
and are available via `site.static_files`. See
[the Variables documentation page](/docs/variables/) and
[`Bunto::Site`]({{ site.repository }}/blob/master/lib/bunto/site.rb)
for more details.

For instance, a generator can inject values computed at build time for template
variables. In the following example the template `reading.html` has two
variables `ongoing` and `done` that we fill in the generator:

{% highlight ruby %}
module Reading
  class Generator < Bunto::Generator
    def generate(site)
      ongoing, done = Book.all.partition(&:ongoing?)

      reading = site.pages.detect {|page| page.name == 'reading.html'}
      reading.data['ongoing'] = ongoing
      reading.data['done'] = done
    end
  end
end
{% endhighlight %}

This is a more complex generator that generates new pages:

{% highlight ruby %}
module Bunto

  class CategoryPage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category'] = category

      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category}"
    end
  end

  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'category_index'
        dir = site.config['category_dir'] || 'categories'
        site.categories.each_key do |category|
          site.pages << CategoryPage.new(site, site.source, File.join(dir, category), category)
        end
      end
    end
  end

end
{% endhighlight %}

In this example, our generator will create a series of files under the
`categories` directory for each category, listing the posts in each category
using the `category_index.html` layout.

Generators are only required to implement one method:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Method</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>generate</code></p>
      </td>
      <td>
        <p>Generates content as a side-effect.</p>
      </td>
    </tr>
  </tbody>
</table>
</div>

## Converters

If you have a new markup language you’d like to use with your site, you can
include it by implementing your own converter. Both the Markdown and
[Textile](https://github.com/bunto/bunto-textile-converter) markup
languages are implemented using this method.

<div class="note info">
  <h5>Remember your YAML Front Matter</h5>
  <p>
    Bunto will only convert files that have a YAML header at the top, even for
    converters you add using a plugin.
  </p>
</div>

Below is a converter that will take all posts ending in `.upcase` and process
them using the `UpcaseConverter`:

{% highlight ruby %}
module Bunto
  class UpcaseConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /^\.upcase$/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      content.upcase
    end
  end
end
{% endhighlight %}

Converters should implement at a minimum 3 methods:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Method</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>matches</code></p>
      </td>
      <td><p>
        Does the given extension match this converter’s list of acceptable
        extensions? Takes one argument: the file’s extension (including the
        dot). Must return <code>true</code> if it matches, <code>false</code>
        otherwise.
      </p></td>
    </tr>
    <tr>
      <td>
        <p><code>output_ext</code></p>
      </td>
      <td><p>
        The extension to be given to the output file (including the dot).
        Usually this will be <code>".html"</code>.
      </p></td>
    </tr>
    <tr>
      <td>
        <p><code>convert</code></p>
      </td>
      <td><p>
        Logic to do the content conversion. Takes one argument: the raw content
        of the file (without YAML Front Matter). Must return a String.
      </p></td>
    </tr>
  </tbody>
</table>
</div>

In our example, `UpcaseConverter#matches` checks if our filename extension is
`.upcase`, and will render using the converter if it is. It will call
`UpcaseConverter#convert` to process the content. In our simple converter we’re
simply uppercasing the entire content string. Finally, when it saves the page,
it will do so with a `.html` extension.

## Commands

As of version 2.5.0, Bunto can be extended with plugins which provide
subcommands for the `bunto` executable. This is possible by including the
relevant plugins in a `Gemfile` group called `:bunto_plugins`:

{% highlight ruby %}
group :bunto_plugins do
  gem "my_fancy_bunto_plugin"
end
{% endhighlight %}

Each `Command` must be a subclass of the `Bunto::Command` class and must
contain one class method: `init_with_program`. An example:

{% highlight ruby %}
class MyNewCommand < Bunto::Command
  class << self
    def init_with_program(prog)
      prog.command(:new) do |c|
        c.syntax "new [options]"
        c.description 'Create a new Bunto site.'

        c.option 'dest', '-d DEST', 'Where the site should go.'

        c.action do |args, options|
          Bunto::Site.new_site_at(options['dest'])
        end
      end
    end
  end
end
{% endhighlight %}

Commands should implement this single class method:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Method</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>init_with_program</code></p>
      </td>
      <td><p>
        This method accepts one parameter, the
        <code><a href="http://github.com/bunto/mercenary#readme">Mercenary::Program</a></code>
        instance, which is the Bunto program itself. Upon the program,
        commands may be created using the above syntax. For more details,
        visit the Mercenary repository on GitHub.com.
      </p></td>
    </tr>
  </tbody>
</table>
</div>

## Tags

If you’d like to include custom liquid tags in your site, you can do so by
hooking into the tagging system. Built-in examples added by Bunto include the
`highlight` and `include` tags. Below is an example of a custom liquid tag that
will output the time the page was rendered:

{% highlight ruby %}
module Bunto
  class RenderTimeTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      "#{@text} #{Time.now}"
    end
  end
end

Liquid::Template.register_tag('render_time', Bunto::RenderTimeTag)
{% endhighlight %}

At a minimum, liquid tags must implement:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Method</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>render</code></p>
      </td>
      <td>
        <p>Outputs the content of the tag.</p>
      </td>
    </tr>
  </tbody>
</table>
</div>

You must also register the custom tag with the Liquid template engine as
follows:

{% highlight ruby %}
Liquid::Template.register_tag('render_time', Bunto::RenderTimeTag)
{% endhighlight %}

In the example above, we can place the following tag anywhere in one of our
pages:

{% highlight ruby %}
{% raw %}
<p>{% render_time page rendered at: %}</p>
{% endraw %}
{% endhighlight %}

And we would get something like this on the page:

{% highlight html %}
<p>page rendered at: Tue June 22 23:38:47 –0500 2010</p>
{% endhighlight %}

### Liquid filters

You can add your own filters to the Liquid template system much like you can
add tags above. Filters are simply modules that export their methods to liquid.
All methods will have to take at least one parameter which represents the input
of the filter. The return value will be the output of the filter.

{% highlight ruby %}
module Bunto
  module AssetFilter
    def asset_url(input)
      "http://www.example.com/#{input}?#{Time.now.to_i}"
    end
  end
end

Liquid::Template.register_filter(Bunto::AssetFilter)
{% endhighlight %}

<div class="note">
  <h5>ProTip™: Access the site object using Liquid</h5>
  <p>
    Bunto lets you access the <code>site</code> object through the
    <code>context.registers</code> feature of Liquid at <code>context.registers[:site]</code>. For example, you can
    access the global configuration file <code>_config.yml</code> using
    <code>context.registers[:site].config</code>.
  </p>
</div>

### Flags

There are two flags to be aware of when writing a plugin:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Flag</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>safe</code></p>
      </td>
      <td>
        <p>
          A boolean flag that informs Bunto whether this plugin may be safely
          executed in an environment where arbitrary code execution is not
          allowed. This is used by GitHub Pages to determine which core plugins
          may be used, and which are unsafe to run. If your plugin does not
          allow for arbitrary code execution, set this to <code>true</code>.
          GitHub Pages still won’t load your plugin, but if you submit it for
          inclusion in core, it’s best for this to be correct!
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>priority</code></p>
      </td>
      <td>
        <p>
          This flag determines what order the plugin is loaded in. Valid values
          are: <code>:lowest</code>, <code>:low</code>, <code>:normal</code>,
          <code>:high</code>, and <code>:highest</code>. Highest priority
          matches are applied first, lowest priority are applied last.
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>

To use one of the example plugins above as an illustration, here is how you’d
specify these two flags:

{% highlight ruby %}
module Bunto
  class UpcaseConverter < Converter
    safe true
    priority :low
    ...
  end
end
{% endhighlight %}

## Hooks

Using hooks, your plugin can exercise fine-grained control over various aspects
of the build process. If your plugin defines any hooks, Bunto will call them
at pre-defined points.

Hooks are registered to a container and an event name. To register one, you
call Bunto::Hooks.register, and pass the container, event name, and code to
call whenever the hook is triggered. For example, if you want to execute some
custom functionality every time Bunto renders a post, you could register a
hook like this:

{% highlight ruby %}
Bunto::Hooks.register :posts, :post_render do |post|
  # code to call after Bunto renders a post
end
{% endhighlight %}

Bunto provides hooks for <code>:site</code>, <code>:pages</code>,
<code>:posts</code>, and <code>:documents</code>. In all cases, Bunto calls your
hooks with the container object as the first callback parameter. But in the
case of <code>:pre_render</code>, your hook will also receive a payload hash as
a second parameter which allows you full control over the variables that are
available while rendering.

The complete list of available hooks is below:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Container</th>
      <th>Event</th>
      <th>Called</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:after_reset</code></p>
      </td>
      <td>
        <p>Just after site reset</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:post_read</code></p>
      </td>
      <td>
        <p>After site data has been read and loaded from disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering the whole site</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering the whole site, but before writing any files</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing the whole site to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:pages</code></p>
      </td>
      <td>
        <p><code>:post_init</code></p>
      </td>
      <td>
        <p>Whenever a page is initialized</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:pages</code></p>
      </td>
      <td>
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering a page</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:pages</code></p>
      </td>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering a page, but before writing it to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:pages</code></p>
      </td>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing a page to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:posts</code></p>
      </td>
      <td>
        <p><code>:post_init</code></p>
      </td>
      <td>
        <p>Whenever a post is initialized</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:posts</code></p>
      </td>
      <td>
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering a post</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:posts</code></p>
      </td>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering a post, but before writing it to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:posts</code></p>
      </td>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing a post to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:documents</code></p>
      </td>
      <td>
        <p><code>:post_init</code></p>
      </td>
      <td>
        <p>Whenever a document is initialized</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:documents</code></p>
      </td>
      <td>
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering a document</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:documents</code></p>
      </td>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering a document, but before writing it to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:documents</code></p>
      </td>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing a document to disk</p>
      </td>
    </tr>
  </tbody>
</table>
</div>

## Available Plugins

You can find a few useful plugins at the following locations:

#### Generators

- [ArchiveGenerator by Ilkka Laukkanen](https://gist.github.com/707909): Uses [this archive page](https://gist.github.com/707020) to generate archives.
- [LESS.js Generator by Andy Fowler](https://gist.github.com/642739): Renders
LESS.js files during generation.
- [Version Reporter by Blake Smith](https://gist.github.com/449491): Creates a version.html file containing the Bunto version.
- [Sitemap.xml Generator by Michael Levin](https://github.com/kinnetica/bunto-plugins): Generates a sitemap.xml file by traversing all of the available posts and pages.
- [Full-text search by Pascal Widdershoven](https://github.com/PascalW/bunto_indextank): Adds full-text search to your Bunto site with a plugin and a bit of JavaScript.
- [AliasGenerator by Thomas Mango](https://github.com/tsmango/bunto_alias_generator): Generates redirect pages for posts when an alias is specified in the YAML Front Matter.
- [Pageless Redirect Generator by Nick Quinlan](https://github.com/nquinlan/bunto-pageless-redirects): Generates redirects based on files in the Bunto root, with support for htaccess style redirects.
- [RssGenerator by Assaf Gelber](https://github.com/agelber/bunto-rss): Automatically creates an RSS 2.0 feed from your posts.
- [Monthly archive generator by Shigeya Suzuki](https://github.com/shigeya/bunto-monthly-archive-plugin): Generator and template which renders monthly archive like MovableType style, based on the work by Ilkka Laukkanen and others above.
- [Category archive generator by Shigeya Suzuki](https://github.com/shigeya/bunto-category-archive-plugin): Generator and template which renders category archive like MovableType style, based on Monthly archive generator.
- [Emoji for Bunto](https://github.com/yihangho/emoji-for-bunto): Seamlessly enable emoji for all posts and pages.
- [Compass integration for Bunto](https://github.com/mscharley/bunto-compass): Easily integrate Compass and Sass with your Bunto website.
- [Pages Directory by Ben Baker-Smith](https://github.com/bbakersmith/bunto-pages-directory): Defines a `_pages` directory for page files which routes its output relative to the project root.
- [Page Collections by Jeff Kolesky](https://github.com/jeffkole/bunto-page-collections): Generates collections of pages with functionality that resembles posts.
- [Windows 8.1 Live Tile Generation by Matt Sheehan](https://github.com/sheehamj13/bunto-live-tiles): Generates Internet Explorer 11 config.xml file and Tile Templates for pinning your site to Windows 8.1.
- [Typescript Generator by Matt Sheehan](https://github.com/sheehamj13/bunto_ts): Generate Javascript on build from your Typescript.
- [Bunto::AutolinkEmail by Ivan Tse](https://github.com/ivantsepp/bunto-autolink_email): Autolink your emails.
- [Bunto::GitMetadata by Ivan Tse](https://github.com/ivantsepp/bunto-git_metadata): Expose Git metadata for your templates.
- [Bunto Http Basic Auth Plugin](https://gist.github.com/snrbrnjna/422a4b7e017192c284b3): Plugin to manage http basic auth for bunto generated pages and directories.
- [Bunto Auto Image by Merlos](https://github.com/merlos/bunto-auto-image): Gets the first image of a post. Useful to list your posts with images or to add [twitter cards](https://dev.twitter.com/cards/overview) to your site.
- [Bunto Portfolio Generator by Shannon Babincsak](https://github.com/codeinpink/bunto-portfolio-generator): Generates project pages and computes related projects out of project data files.
- [Bunto-Umlauts by Arne Gockeln](https://github.com/webchef/bunto-umlauts): This generator replaces all german umlauts (äöüß) case sensitive with html.
- [Bunto Flickr Plugin](https://github.com/lawmurray/indii-bunto-flickr) by [Lawrence Murray](http://www.indii.org): Generates posts for photos uploaded to a Flickr photostream.
- [Bunto::Paginate::Category](https://github.com/midnightSuyama/bunto-paginate-category): Pagination Generator for Bunto Category.

#### Converters

- [Textile converter](https://github.com/bunto/bunto-textile-converter): Convert `.textile` files into HTML. Also includes the `textilize` Liquid filter.
- [Slim plugin](https://github.com/slim-template/bunto-slim): Slim converter and includes for Bunto with support for Liquid tags.
- [Jade plugin by John Papandriopoulos](https://github.com/snappylabs/jade-bunto-plugin): Jade converter for Bunto.
- [HAML plugin by Sam Z](https://gist.github.com/517556): HAML converter for Bunto.
- [HAML-Sass Converter by Adam Pearson](https://gist.github.com/481456): Simple HAML-Sass converter for Bunto. [Fork](https://gist.github.com/528642) by Sam X.
- [Sass SCSS Converter by Mark Wolfe](https://gist.github.com/960150): Sass converter which uses the new CSS compatible syntax, based Sam X’s fork above.
- [LESS Converter by Jason Graham](https://gist.github.com/639920): Convert LESS files to CSS.
- [LESS Converter by Josh Brown](https://gist.github.com/760265): Simple LESS converter.
- [Upcase Converter by Blake Smith](https://gist.github.com/449463): An example Bunto converter.
- [CoffeeScript Converter by phaer](https://gist.github.com/959938): A [CoffeeScript](http://coffeescript.org) to Javascript converter.
- [Markdown References by Olov Lassus](https://github.com/olov/bunto-references): Keep all your markdown reference-style link definitions in one \_references.md file.
- [Stylus Converter](https://gist.github.com/988201): Convert .styl to .css.
- [ReStructuredText Converter](https://github.com/xdissent/bunto-rst): Converts ReST documents to HTML with Pygments syntax highlighting.
- [Bunto-pandoc-plugin](https://github.com/dsanson/bunto-pandoc-plugin): Use pandoc for rendering markdown.
- [Bunto-pandoc-multiple-formats](https://github.com/fauno/bunto-pandoc-multiple-formats) by [edsl](https://github.com/edsl): Use pandoc to generate your site in multiple formats. Supports pandoc’s markdown extensions.
- [Transform Layouts](https://gist.github.com/1472645): Allows HAML layouts (you need a HAML Converter plugin for this to work).
- [Org-mode Converter](https://gist.github.com/abhiyerra/7377603): Org-mode converter for Bunto.
- [Customized Kramdown Converter](https://github.com/mvdbos/kramdown-with-pygments): Enable Pygments syntax highlighting for Kramdown-parsed fenced code blocks.
- [Bigfootnotes Plugin](https://github.com/TheFox/bunto-bigfootnotes): Enables big footnotes for Kramdown.
- [AsciiDoc Plugin](https://github.com/asciidoctor/bunto-asciidoc): AsciiDoc convertor for Bunto using [Asciidoctor](http://asciidoctor.org/).
- [Lazy Tweet Embedding](https://github.com/takuti/bunto-lazy-tweet-embedding): Automatically convert tweet urls into twitter cards.
- [bunto-commonmark](https://github.com/pathawks/bunto-commonmark): Markdown converter that uses [libcmark](https://github.com/jgm/CommonMark), the reference parser for CommonMark.

#### Filters

- [Truncate HTML](https://github.com/MattHall/truncatehtml) by [Matt Hall](http://codebeef.com): A Bunto filter that truncates HTML while preserving markup structure.
- [Domain Name Filter by Lawrence Woodman](https://github.com/LawrenceWoodman/domain_name-liquid_filter): Filters the input text so that just the domain name is left.
- [Summarize Filter by Mathieu Arnold](https://gist.github.com/731597): Remove markup after a `<div id="extended">` tag.
- [i18n_filter](https://github.com/gacha/gacha.id.lv/blob/master/_plugins/i18n_filter.rb): Liquid filter to use I18n localization.
- [Smilify](https://github.com/SaswatPadhi/bunto_smilify) by [SaswatPadhi](https://github.com/SaswatPadhi): Convert text emoticons in your content to themeable smiley pics.
- [Read in X Minutes](https://gist.github.com/zachleat/5792681) by [zachleat](https://github.com/zachleat): Estimates the reading time of a string (for blog post content).
- [Bunto-timeago](https://github.com/markets/bunto-timeago): Converts a time value to the time ago in words.
- [pluralize](https://github.com/bdesham/pluralize): Easily combine a number and a word into a grammatically-correct amount like “1 minute” or “2 minute**s**”.
- [reading_time](https://github.com/bdesham/reading_time): Count words and estimate reading time for a piece of text, ignoring HTML elements that are unlikely to contain running text.
- [Table of Content Generator](https://github.com/dafi/bunto-toc-generator): Generate the HTML code containing a table of content (TOC), the TOC can be customized in many way, for example you can decide which pages can be without TOC.
- [bunto-humanize](https://github.com/23maverick23/bunto-humanize): This is a port of the Django app humanize which adds a "human touch" to data. Each method represents a Fluid type filter that can be used in your Bunto site templates. Given that Bunto produces static sites, some of the original methods do not make logical sense to port (e.g. naturaltime).
- [Bunto-Ordinal](https://github.com/PatrickC8t/Bunto-Ordinal): Bunto liquid filter to output a date ordinal such as "st", "nd", "rd", or "th".
- [Deprecated articles keeper](https://github.com/kzykbys/BuntoPlugins) by [Kazuya Kobayashi](http://blog.kazuya.co/): A simple Bunto filter which monitor how old an article is.
- [Bunto-jalali](https://github.com/mehdisadeghi/bunto-jalali) by [Mehdi Sadeghi](http://mehdix.ir): A simple Gregorian to Jalali date converter filter.
- [Bunto Thumbnail Filter](https://github.com/matallo/bunto-thumbnail-filter): Related posts thumbnail filter.
- [Bunto-Smartify](https://github.com/pathawks/bunto-smartify): SmartyPants filter. Make &quot;quotes&quot; &ldquo;curly&rdquo;
- [liquid-md5](https://github.com/pathawks/liquid-md5): Returns an MD5 hash. Helpful for generating Gravatars in templates.
- [bunto-roman](https://github.com/paulrobertlloyd/bunto-roman): A liquid filter for Bunto that converts numbers into Roman numerals.
- [bunto-typogrify](https://github.com/myles/bunto-typogrify): A Bunto plugin that brings the functions of [typogruby](http://avdgaag.github.io/typogruby/).
- [Bunto Email Protect](https://github.com/vwochnik/bunto-email-protect): Email protection liquid filter for Bunto

#### Tags

- [Asset Path Tag](https://github.com/samrayner/bunto-asset-path-plugin) by [Sam Rayner](http://www.samrayner.com/): Allows organisation of assets into subdirectories by outputting a path for a given file relative to the current post or page.
- [Delicious Plugin by Christian Hellsten](https://github.com/christianhellsten/bunto-plugins): Fetches and renders bookmarks from delicious.com.
- [Ultraviolet Plugin by Steve Alex](https://gist.github.com/480380): Bunto tag for the [Ultraviolet](https://github.com/grosser/ultraviolet) code highligher.
- [Tag Cloud Plugin by Ilkka Laukkanen](https://gist.github.com/710577): Generate a tag cloud that links to tag pages.
- [GIT Tag by Alexandre Girard](https://gist.github.com/730347): Add Git activity inside a list.
- [MathJax Liquid Tags by Jessy Cowan-Sharp](https://gist.github.com/834610): Simple liquid tags for Bunto that convert inline math and block equations to the appropriate MathJax script tags.
- [Non-JS Gist Tag by Brandon Tilley](https://gist.github.com/1027674) A Liquid tag that embeds Gists and shows code for non-JavaScript enabled browsers and readers.
- [Render Time Tag by Blake Smith](https://gist.github.com/449509): Displays the time a Bunto page was generated.
- [Status.net/OStatus Tag by phaer](https://gist.github.com/912466): Displays the notices in a given status.net/ostatus feed.
- [Embed.ly client by Robert Böhnke](https://github.com/robb/bunto-embedly-client): Autogenerate embeds from URLs using oEmbed.
- [Logarithmic Tag Cloud](https://gist.github.com/2290195): Flexible. Logarithmic distribution. Documentation inline.
- [oEmbed Tag by Tammo van Lessen](https://gist.github.com/1455726): Enables easy content embedding (e.g. from YouTube, Flickr, Slideshare) via oEmbed.
- [FlickrSetTag by Thomas Mango](https://github.com/tsmango/bunto_flickr_set_tag): Generates image galleries from Flickr sets.
- [Tweet Tag by Scott W. Bradley](https://github.com/scottwb/bunto-tweet-tag): Liquid tag for [Embedded Tweets](https://dev.twitter.com/docs/embedded-tweets) using Twitter’s shortcodes.
- [Bunto Twitter Plugin](https://github.com/rob-murray/bunto-twitter-plugin): A Liquid tag plugin that renders Tweets from Twitter API. Currently supports the [oEmbed](https://dev.twitter.com/rest/reference/get/statuses/oembed) API.
- [Bunto-contentblocks](https://github.com/rustygeldmacher/bunto-contentblocks): Lets you use Rails-like content_for tags in your templates, for passing content from your posts up to your layouts.
- [Generate YouTube Embed](https://gist.github.com/1805814) by [joelverhagen](https://github.com/joelverhagen): Bunto plugin which allows you to embed a YouTube video in your page with the YouTube ID. Optionally specify width and height dimensions. Like “oEmbed Tag” but just for YouTube.
- [Bunto-beastiepress](https://github.com/okeeblow/bunto-beastiepress): FreeBSD utility tags for Bunto sites.
- [Jsonball](https://gist.github.com/1895282): Reads json files and produces maps for use in Bunto files.
- [Bibbunto](https://github.com/pablooliveira/bibbunto): Render BibTeX-formatted bibliographies/citations included in posts and pages using bibtex2html.
- [Bunto-citation](https://github.com/archome/bunto-citation): Render BibTeX-formatted bibliographies/citations included in posts and pages (pure Ruby).
- [Bunto Dribbble Set Tag](https://github.com/ericdfields/Bunto-Dribbble-Set-Tag): Builds Dribbble image galleries from any user.
- [Debbugs](https://gist.github.com/2218470): Allows posting links to Debian BTS easily.
- [Refheap_tag](https://github.com/aburdette/refheap_tag): Liquid tag that allows embedding pastes from [refheap](https://www.refheap.com/).
- [Bunto-devonly_tag](https://gist.github.com/2403522): A block tag for including markup only during development.
- [BuntoGalleryTag](https://github.com/redwallhp/BuntoGalleryTag) by [redwallhp](https://github.com/redwallhp): Generates thumbnails from a directory of images and displays them in a grid.
- [Youku and Tudou Embed](https://gist.github.com/Yexiaoxing/5891929): Liquid plugin for embedding Youku and Tudou videos.
- [Bunto-swfobject](https://github.com/sectore/bunto-swfobject): Liquid plugin for embedding Adobe Flash files (.swf) using [SWFObject](http://code.google.com/p/swfobject/).
- [Bunto Picture Tag](https://github.com/robwierzbowski/bunto-picture-tag): Easy responsive images for Bunto. Based on the proposed [`<picture>`](https://html.spec.whatwg.org/multipage/embedded-content.html#the-picture-element) element, polyfilled with Scott Jehl’s [Picturefill](https://github.com/scottjehl/picturefill).
- [Bunto Image Tag](https://github.com/robwierzbowski/bunto-image-tag): Better images for Bunto. Save image presets, generate resized images, and add classes, alt text, and other attributes.
- [Bunto Responsive Image](https://github.com/wildlyinaccurate/bunto-responsive-image): Responsive images for Bunto. Automatically resizes images, supports all responsive methods (`<picture>`, `srcset`, Imager.js, etc), super-flexible configuration.
- [Ditaa Tag](https://github.com/matze/bunto-ditaa) by [matze](https://github.com/matze): Renders ASCII diagram art into PNG images and inserts a figure tag.
- [Bunto Suggested Tweet](https://github.com/davidensinger/bunto-suggested-tweet) by [David Ensinger](https://github.com/davidensinger/): A Liquid tag for Bunto that allows for the embedding of suggested tweets via Twitter’s Web Intents API.
- [Bunto Date Chart](https://github.com/GSI/bunto_date_chart) by [GSI](https://github.com/GSI): Block that renders date line charts based on textile-formatted tables.
- [Bunto Image Encode](https://github.com/GSI/bunto_image_encode) by [GSI](https://github.com/GSI): Tag that renders base64 codes of images fetched from the web.
- [Bunto Quick Man](https://github.com/GSI/bunto_quick_man) by [GSI](https://github.com/GSI): Tag that renders pretty links to man page sources on the internet.
- [bunto-font-awesome](https://gist.github.com/23maverick23/8532525): Quickly and easily add Font Awesome icons to your posts.
- [Lychee Gallery Tag](https://gist.github.com/tobru/9171700) by [tobru](https://github.com/tobru): Include [Lychee](http://lychee.electerious.com/) albums into a post. For an introduction, see [Bunto meets Lychee - A Liquid Tag plugin](https://tobrunet.ch/articles/bunto-meets-lychee-a-liquid-tag-plugin/)
- [Image Set/Gallery Tag](https://github.com/callmeed/bunto-image-set) by [callmeed](https://github.com/callmeed): Renders HTML for an image gallery from a folder in your Bunto site. Just pass it a folder name and class/tag options.
- [bunto_figure](https://github.com/lmullen/bunto_figure): Generate figures and captions with links to the figure in a variety of formats
- [Bunto GitHub Sample Tag](https://github.com/bwillis/bunto-github-sample): A liquid tag to include a sample of a github repo file in your Bunto site.
- [Bunto Project Version Tag](https://github.com/rob-murray/bunto-version-plugin): A Liquid tag plugin that renders a version identifier for your Bunto site sourced from the git repository containing your code.
- [Piwigo Gallery](https://github.com/AlessandroLorenzi/piwigo_gallery) by [Alessandro Lorenzi](http://www.alorenzi.eu/): Bunto plugin to generate thumbnails from a Piwigo gallery and display them with a Liquid tag
- [mathml.rb](https://github.com/tmthrgd/bunto-plugins) by Tom Thorogood: A plugin to convert TeX mathematics into MathML for display.
- [webmention_io.rb](https://github.com/aarongustafson/bunto-webmention_io) by [Aaron Gustafson](http://aaron-gustafson.com/): A plugin to enable [webmention](http://indiewebcamp.com/webmention) integration using [Webmention.io](http://webmention.io). Includes an optional JavaScript for updating webmentions automatically between publishes and, if available, in realtime using WebSockets.
- [Bunto 500px Embed](https://github.com/lkorth/bunto-500px-embed) by Luke Korth. A Liquid tag plugin that embeds [500px](https://500px.com/) photos.
- [inline\_highlight](https://github.com/bdesham/inline_highlight): A tag for inline syntax highlighting.
- [bunto-mermaid](https://github.com/jasonbellamy/bunto-mermaid): Simplify the creation of mermaid diagrams and flowcharts in your posts and pages.
- [twa](https://github.com/Ezmyrelda/twa): Twemoji Awesome plugin for Bunto. Liquid tag allowing you to use twitter emoji in your bunto pages.
- [bunto-files](https://github.com/x43x61x69/bunto-files) by [Zhi-Wei Cai](http://vox.vg/): Output relative path strings and other info regarding specific assets.
- [Fetch remote file content](https://github.com/dimitri-koenig/bunto-plugins) by [Dimitri König](https://www.dimitrikoenig.net/): Using `remote_file_content` tag you can fetch the content of a remote file and include it as if you would put the content right into your markdown file yourself. Very useful for including code from github repo's to always have a current repo version.
- [bunto-asciinema](https://github.com/mnuessler/bunto-asciinema): A tag for embedding asciicasts recorded with [asciinema](https://asciinema.org) in your Bunto pages.
- [Bunto-Youtube](https://github.com/dommmel/bunto-youtube)  A Liquid tag that embeds Youtube videos. The default emded markup is responsive but you can also specify your own by using an include/partial.
- [Bunto Flickr Plugin](https://github.com/lawmurray/indii-bunto-flickr) by [Lawrence Murray](http://www.indii.org): Embeds Flickr photosets (albums) as a gallery of thumbnails, with lightbox links to larger images.
- [bunto-figure](https://github.com/paulrobertlloyd/bunto-figure): A liquid tag for Bunto that generates `<figure>` elements.

#### Collections

- [Bunto Plugins by Recursive Design](https://github.com/recurser/bunto-plugins): Plugins to generate Project pages from GitHub readmes, a Category page, and a Sitemap generator.
- [Company website and blog plugins](https://github.com/flatterline/bunto-plugins) by Flatterline, a [Ruby on Rails development company](http://flatterline.com/): Portfolio/project page generator, team/individual page generator, an author bio liquid tag for use on posts, and a few other smaller plugins.
- [Bunto plugins by Aucor](https://github.com/aucor/bunto-plugins): Plugins for trimming unwanted newlines/whitespace and sorting pages by weight attribute.

#### Other

- [ditaa-ditaa](https://github.com/tmthrgd/ditaa-ditaa) by Tom Thorogood: a drastic revision of bunto-ditaa that renders diagrams drawn using ASCII art into PNG images.
- [Pygments Cache Path by Raimonds Simanovskis](https://github.com/rsim/blog.rayapps.com/blob/master/_plugins/pygments_cache_patch.rb): Plugin to cache syntax-highlighted code from Pygments.
- [Draft/Publish Plugin by Michael Ivey](https://gist.github.com/49630): Save posts as drafts.
- [Growl Notification Generator by Tate Johnson](https://gist.github.com/490101): Send Bunto notifications to Growl.
- [Growl Notification Hook by Tate Johnson](https://gist.github.com/525267): Better alternative to the above, but requires his “hook” fork.
- [Related Posts by Lawrence Woodman](https://github.com/LawrenceWoodman/related_posts-bunto_plugin): Overrides `site.related_posts` to use categories to assess relationship.
- [Tiered Archives by Eli Naeher](https://gist.github.com/88cda643aa7e3b0ca1e5): Create tiered template variable that allows you to group archives by year and month.
- [Bunto-localization](https://github.com/blackwinter/bunto-localization): Bunto plugin that adds localization features to the rendering engine.
- [Bunto-rendering](https://github.com/blackwinter/bunto-rendering): Bunto plugin to provide alternative rendering engines.
- [Bunto-pagination](https://github.com/blackwinter/bunto-pagination): Bunto plugin to extend the pagination generator.
- [Bunto-tagging](https://github.com/pattex/bunto-tagging): Bunto plugin to automatically generate a tag cloud and tag pages.
- [Bunto-scholar](https://github.com/inukshuk/bunto-scholar): Bunto extensions for the blogging scholar.
- [Bunto-asset_bundler](https://github.com/moshen/bunto-asset_bundler): Bundles and minifies JavaScript and CSS.
- [Bunto-assets](http://ixti.net/bunto-assets/) by [ixti](https://github.com/ixti): Rails-alike assets pipeline (write assets in CoffeeScript, Sass, LESS etc; specify dependencies for automatic bundling using simple declarative comments in assets; minify and compress; use JST templates; cache bust; and many-many more).
- [JAPR](https://github.com/kitsched/japr): Bunto Asset Pipeline Reborn - Powerful asset pipeline for Bunto that collects, converts and compresses JavaScript and CSS assets.
- [File compressor](https://gist.github.com/2758691) by [mytharcher](https://github.com/mytharcher): Compress HTML and JavaScript files on site build.
- [Bunto-minibundle](https://github.com/tkareine/bunto-minibundle): Asset bundling and cache busting using external minification tool of your choice. No gem dependencies.
- [Singlepage-bunto](https://github.com/JCB-K/singlepage-bunto) by [JCB-K](https://github.com/JCB-K): Turns Bunto into a dynamic one-page website.
- [generator-buntorb](https://github.com/robwierzbowski/generator-buntorb): A generator that wraps Bunto in [Yeoman](http://yeoman.io/), a tool collection and workflow for building modern web apps.
- [grunt-bunto](https://github.com/dannygarcia/grunt-bunto): A straightforward [Grunt](http://gruntjs.com/) plugin for Bunto.
- [bunto-postfiles](https://github.com/indirect/bunto-postfiles): Add `_postfiles` directory and {% raw %}`{{ postfile }}`{% endraw %} tag so the files a post refers to will always be right there inside your repo.
- [A layout that compresses HTML](http://jch.penibelst.de/): GitHub Pages compatible, configurable way to compress HTML files on site build.
- [Bunto CO₂](https://github.com/wdenton/bunto-co2): Generates HTML showing the monthly change in atmospheric CO₂ at the Mauna Loa observatory in Hawaii.
- [remote-include](http://www.northfieldx.co.uk/remote-include/): Includes files using remote URLs
- [bunto-minifier](https://github.com/digitalsparky/bunto-minifier): Minifies HTML, XML, CSS, and Javascript both inline and as separate files utilising yui-compressor and htmlcompressor.
- [Bunto views router](https://bitbucket.org/nyufac/bunto-views-router): Simple router between generator plugins and templates.
- [Bunto Language Plugin](https://github.com/vwochnik/bunto-language-plugin): Bunto 3.0-compatible multi-language plugin for posts, pages and includes.
- [Bunto Deploy](https://github.com/vwochnik/bunto-deploy): Adds a `deploy` sub-command to Bunto.
- [Official Contentful Bunto Plugin](https://github.com/contentful/bunto-contentful-data-import): Adds a `contentful` sub-command to Bunto to import data from Contentful.

#### Editors

- [sublime-bunto](https://github.com/23maverick23/sublime-bunto): A Sublime Text package for Bunto static sites. This package should help creating Bunto sites and posts easier by providing access to key template tags and filters, as well as common completions and a current date/datetime command (for dating posts). You can install this package manually via GitHub, or via [Package Control](https://packagecontrol.io/packages/Bunto).
- [vim-bunto](https://github.com/parkr/vim-bunto): A vim plugin to generate
  new posts and run `bunto build` all without leaving vim.
- [markdown-writer](https://atom.io/packages/markdown-writer): An Atom package for Bunto. It can create new posts/drafts, manage tags/categories, insert link/images and add many useful key mappings.
- [Wordpress2Bunto](https://wordpress.org/plugins/wp2bunto/): A Wordpress plugin that allows you to use Wordpress as your editor and (automatically) export content in to Bunto. WordPress2Bunto attempts to marry these two systems together in order to make a site that can be easily managed from all devices.

<div class="note info">
  <h5>Bunto Plugins Wanted</h5>
  <p>
    If you have a Bunto plugin that you would like to see added to this list,
    you should <a href="../contributing/">read the contributing page</a> to find
    out how to make that happen.
  </p>
</div>
