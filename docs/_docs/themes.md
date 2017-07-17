---
title: Themes
permalink: /docs/themes/
---

Bunto has an extensive theme system that allows you to leverage community-maintained templates and styles to customize your site's presentation. Bunto themes package up layouts, includes, and stylesheets in a way that can be overridden by your site's content.

## Understanding gem-based themes

When you [create a new Bunto site](/docs/quickstart) (by running the `bunto new <PATH>` command), Bunto installs a site that uses a gem-based theme called [Minima](https://github.com/bunto/minima).

With gem-based themes, some of the site's directories (such as the `assets`, `_layouts`, `_includes`, and `_sass` directories) are stored in the theme's gem, hidden from your immediate view. Yet all of the necessary directories will be read and processed during Bunto's build process.

In the case of Minima, you see only the following files in your Bunto site directory:

```
├── Gemfile
├── Gemfile.lock
├── _config.yml
├── _posts
│   └── 2016-12-04-welcome-to-bunto.markdown
├── about.md
└── index.md
```

The `Gemfile` and `Gemfile.lock` files are used by Bundler to keep track of the required gems and gem versions you need to build your Bunto site.

Gem-based themes make it easy for theme developers to make updates available to anyone who has the theme gem. When there's an update, theme developers push the update to RubyGems.

If you have the theme gem, you can (if you desire) run `bundle update` to update all gems in your project. Or you can run `bundle update <THEME>`, replacing `<THEME>` with the theme name, such as `minima`, to just update the theme gem. Any new files or updates the theme developer has made (such as to stylesheets or includes) will be pulled into your project automatically.

The goal of gem-based themes is to allow you to get all the benefits of a robust, continually updated theme without having all the theme's files getting in your way and over-complicating what might be your primary focus: creating content.

## Overriding theme defaults

Bunto themes set default layouts, includes, and stylesheets. However, you can override any of the theme defaults with your own site content.

For example, if your selected theme has a `page` layout, you can override the theme's layout by creating your own `page` layout in the `_layouts` directory (that is, `_layouts/page.html`).

Bunto will look first to your site's content before looking to the theme's defaults for any requested file in the following folders:

- `/assets`
- `/_layouts`
- `/_includes`
- `/_sass`

Refer to your selected theme's documentation and source repository for more information on what files you can override.
{: .note .info}

To locate theme's files on your computer:

1. Run `bundle show` followed by the name of the theme's gem, e.g., `bundle show minima` for default Bunto's theme.

   This returns the location of the gem-based theme files. For example, Minima theme's files are located in `/usr/local/lib/ruby/gems/2.3.0/gems/minima-2.1.0` on macOS.

2. Open the theme's directory in Finder or Explorer:

   ```shell
   # On MacOS
   open $(bundle show minima)
   # On Windows
   explorer /usr/local/lib/ruby/gems/2.3.0/gems/minima-2.1.0
   ```

   A Finder or Explorer window opens showing the theme's files and directories. The Minima theme gem contains these files:

    ```
    ├── LICENSE.txt
    ├── README.md
    ├── _includes
    │   ├── disqus_comments.html
    │   ├── footer.html
    │   ├── google-analytics.html
    │   ├── head.html
    │   ├── header.html
    │   ├── icon-github.html
    │   ├── icon-github.svg
    │   ├── icon-twitter.html
    │   └── icon-twitter.svg
    ├── _layouts
    │   ├── default.html
    │   ├── home.html
    │   ├── page.html
    │   └── post.html
    ├── _sass
    │   ├── minima
    │   │   ├── _base.scss
    │   │   ├── _layout.scss
    │   │   └── _syntax-highlighting.scss
    │   └── minima.scss
    └── assets
        └── main.scss
     ```

     With a clear understanding of the theme's files, you can now override any theme file by creating a similarly named file in your Bunto site directory.

     Let's say you want to override Minima's footer. In your Bunto site, create an `_includes` folder and add a file in it called `footer.html`. Bunto will now use your site's `footer.html` file instead of the `footer.html` file from the Minima theme gem.

## Converting gem-based themes to regular themes

Suppose you want to get rid of the gem-based theme and convert it to a regular theme, where all files are present in your Bunto site directory, with nothing stored in the theme gem.

To do this, copy the files from the theme gem's directory into your Bunto site directory. (For example, copy them to `/myblog` if you created your Bunto site at `/myblog`. See the previous section for details.)

Then remove references to the theme gem in `Gemfile` and configuration. For example, to remove `minima`:

- Open `Gemfile` and remove `gem "minima", "~> 2.0"`.
- Open `_config.yml` and remove `theme: minima`.

Now `bundle update` will no longer get updates for the theme gem.

## Installing a gem-based theme {#installing-a-theme}

The `bunto new <PATH>` command isn't the only way to create a new Bunto site with a gem-based theme. You can also find gem-based themes online and incorporate them into your Bunto project.

For example, search for [bunto theme on RubyGems](https://rubygems.org/search?utf8=%E2%9C%93&query=bunto-theme) to find other gem-based themes. (Note that not all themes are using `bunto-theme` as a convention in the theme name.)

To install a gem-based theme:

1. Add the theme to your site's `Gemfile`:

   ```sh
   gem "bunto-theme-awesome"
   ```

2. Install the theme:

   ```sh
   bundle install
   ```

3. Add the following to your site's `_config.yml` to activate the theme:

   ```sh
   theme: bunto-theme-awesome
   ```

4. Build your site:

   ```sh
   bundle exec bunto serve
   ```

You can have multiple themes listed in your site's `Gemfile`, but only one theme can be selected in your site's `_config.yml`. {: .note .info }

If you're publishing your Bunto site on [GitHub Pages](https://pages.github.com/), note that GitHub Pages supports only some gem-based themes. See [Supported Themes](https://pages.github.com/themes/) in GitHub's documentation to see which themes are supported.

## Creating a gem-based theme

If you're a Bunto theme developer (rather than just a consumer of themes), you can package up your theme in RubyGems and allow users to install it through Bundler.

If you're unfamiliar with creating Ruby gems, don't worry. Bunto will help you scaffold a new theme with the `new-theme` command. Run `bunto new-theme` with the theme name as an argument.

Here is an example:

```sh
bunto new-theme bunto-theme-awesome
    create /path/to/bunto-theme-awesome/_layouts
    create /path/to/bunto-theme-awesome/_includes
    create /path/to/bunto-theme-awesome/_sass
    create /path/to/bunto-theme-awesome/_layouts/page.html
    create /path/to/bunto-theme-awesome/_layouts/post.html
    create /path/to/bunto-theme-awesome/_layouts/default.html
    create /path/to/bunto-theme-awesome/Gemfile
    create /path/to/bunto-theme-awesome/bunto-theme-awesome.gemspec
    create /path/to/bunto-theme-awesome/README.md
    create /path/to/bunto-theme-awesome/LICENSE.txt
    initialize /path/to/bunto-theme-awesome/.git
    create /path/to/bunto-theme-awesome/.gitignore
Your new Bunto theme, bunto-theme-awesome, is ready for you in /path/to/bunto-theme-awesome!
For help getting started, read /path/to/bunto-theme-awesome/README.md.
```

Add your template files in the corresponding folders. Then complete the `.gemspec` and the README files according to your needs.

### Layouts and includes

Theme layouts and includes work just like they work in any Bunto site. Place layouts in your theme's `/_layouts` folder, and place includes in your themes `/_includes` folder.

For example, if your theme has a `/_layouts/page.html` file, and a page has `layout: page` in its YAML front matter, Bunto will first look to the site's `_layouts` folder for the `page` layout, and if none exists, will use your theme's `page` layout.

### Assets

Any file in `/assets` will be copied over to the user's site upon build unless they have a file with the same relative path. You can ship any kind of asset here: SCSS, an image, a webfont, etc. These files behave like pages and static files in Bunto:

- If the file has [YAML front matter](../docs/frontmatter/) at the top, it will be rendered.
- If the file does not have YAML front matter, it will simply be copied over into the resulting site.

This allows theme creators to ship a default `/assets/styles.scss` file which their layouts can depend on as `/assets/styles.css`.

All files in `/assets` will be output into the compiled site in the `/assets` folder just as you'd expect from using Bunto on your sites.

### Stylesheets

Your theme's stylesheets should be placed in your theme's `_sass` folder, again, just as you would when authoring a Bunto site.

```
_sass
├── bunto-theme-awesome.scss
```

Your theme's styles can be included in the user's stylesheet using the `@import` directive.

```css
{% raw %}@import "{{ site.theme }}";{% endraw %}
```

### Documenting your theme

Your theme should include a `/README.md` file, which explains how site authors can install and use your theme. What layouts are included? What includes? Do they need to add anything special to their site's configuration file?

### Adding a screenshot

Themes are visual. Show users what your theme looks like by including a screenshot as `/screenshot.png` within your theme's repository where it can be retrieved programatically. You can also include this screenshot within your theme's documentation.

### Previewing your theme

To preview your theme as you're authoring it, it may be helpful to add dummy content in, for example, `/index.html` and `/page.html` files. This will allow you to use the `bunto build` and `bunto serve` commands to preview your theme, just as you'd preview a Bunto site.

If you do preview your theme locally, be sure to add `/_site` to your theme's `.gitignore` file to prevent the compiled site from also being included when you distribute your theme. {: .info .note}

### Publishing your theme

Themes are published via [RubyGems.org](https://rubygems.org). You will need a RubyGems account, which you can [create for free](https://rubygems.org/sign_up).

1. First, package your theme, by running the following command, replacing `bunto-theme-awesome` with the name of your theme:

   ```sh
   gem build bunto-theme-awesome.gemspec
   ```

2. Next, push your packaged theme up to the RubyGems service, by running the following command, again replacing `bunto-theme-awesome` with the name of your theme:

   ```sh
   gem push bunto-theme-awesome-*.gem
   ```

3. To release a new version of your theme, update the version number in the gemspec file, ( `bunto-theme-awesome.gemspec` in this example ), and then repeat Steps 1 & 2 above. We recommend that you follow [Semantic Versioning](http://semver.org/) while bumping your theme-version.
