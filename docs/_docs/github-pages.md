---
title: GitHub Pages
permalink: /docs/github-pages/
---

[GitHub Pages](https://pages.github.com) are public web pages for users,
organizations, and repositories, that are freely hosted on GitHub's
`github.io` domain or on a custom domain name of your choice. GitHub Pages are
powered by Bunto behind the scenes, so in addition to supporting regular HTML
content, they’re also a great way to host your Bunto-powered website for free.

Never built a website with GitHub Pages before? [See this marvelous guide by
Jonathan McGlone to get you up and running](http://jmcglone.com/guides/github-pages/).
This guide will teach you what you need to know about Git, GitHub, and Bunto to create your very own website on GitHub Pages.

### Project Page URL Structure

Sometimes it's nice to preview your Bunto site before you push your `gh-pages`
branch to GitHub. However, the subdirectory-like URL structure GitHub uses for
Project Pages complicates the proper resolution of URLs. In order to assure your site builds properly, use `site.github.url` in your URL's.

```html
{% raw %}
<!-- Useful for styles with static names... -->
<link href="{{ site.github.url }}/path/to/css.css" rel="stylesheet">
<!-- and for documents/pages whose URL's can change... -->
[{{ page.title }}]("{{ page.url | prepend: site.github.url }}")
{% endraw %}
```

This way you can preview your site locally from the site root on localhost,
but when GitHub generates your pages from the gh-pages branch all the URLs
will resolve properly.

## Deploying Bunto to GitHub Pages

GitHub Pages work by looking at certain branches of repositories on GitHub.
There are two basic types available: user/organization pages and project pages.
The way to deploy these two types of sites are nearly identical, except for a
few minor details.

<div class="note protip" markdown="1">
<div markdown="1">
</div>

##### Use the `github-pages` gem

Our friends at GitHub have provided the
[github-pages](https://github.com/github/pages-gem)
gem which is used to manage Bunto and its dependencies on
GitHub Pages. Using it in your projects means that when you deploy
your site to GitHub Pages, you will not be caught by unexpected
differences between various versions of the gems. To use the
currently-deployed version of the gem in your project, add the
following to your `Gemfile`:

<div class="code-block" markdown="1">
<div markdown="1">
</div>

```ruby
source 'https://rubygems.org'

require 'json'
require 'open-uri'
versions = JSON.parse(open('https://pages.github.com/versions.json').read)

gem 'github-pages', versions['github-pages']
```
</div>

This will ensure that when you run `bundle install`, you
have the correct version of the `github-pages` gem.

If that fails, simplify it:

<div class="code-block" markdown="1">
<div markdown="1">
</div>

```ruby
source 'https://rubygems.org'

gem 'github-pages'
```
</div>

And be sure to run `bundle update` often.

If you like to install `pages-gem` on Windows you can find instructions by Jens Willmer on
[how to install github-pages gem on Windows (x64)](https://jwillmer.de/blog/tutorial/how-to-install-bunto-and-pages-gem-on-windows-10-x46#github-pages-and-plugins).
</div>

<div class="note info">
  <h5>Installing <code>github-pages</code> gem on Windows</h5>
  <p>
    While Windows is not officially supported, it is possible
    to install <code>github-pages</code> gem on Windows.
    Special instructions can be found on our
    <a href="../windows/#installation">Windows-specific docs page</a>.
  </p>
</div>

### User and Organization Pages

User and organization pages live in a special GitHub repository dedicated to
only the GitHub Pages files. This repository must be named after the account
name. For example, [@mojombo’s user page repository](https://github.com/mojombo/mojombo.github.io) has the name
`mojombo.github.io`.

Content from the `master` branch of your repository will be used to build and
publish the GitHub Pages site, so make sure your Bunto site is stored there.

<div class="note info">
  <h5>Custom domains do not affect repository names</h5>
  <p>
    GitHub Pages are initially configured to live under the
    <code>username.github.io</code> subdomain, which is why repositories must
    be named this way <strong>even if a custom domain is being used</strong>.
  </p>
</div>

### Project Pages

Unlike user and organization Pages, Project Pages are kept in the same
repository as the project they are for, except that the website content is
stored in a specially named `gh-pages` branch or in a `docs` folder on the
`master` branch. The content will be rendered using Bunto, and the output
will become available under a subpath of your user pages subdomain, such as
`username.github.io/project` (unless a custom domain is specified).

The Bunto project repository itself is a perfect example of this branch
structure—the [master branch]({{ site.repository }}) contains the
actual software project for Bunto, and the Bunto website that you’re
looking at right now is contained in the [docs
folder]({{ site.repository }}/tree/master/docs) of the same repository.

Please refer to GitHub official documentation on
[user, organization and project pages](https://help.github.com/articles/user-organization-and-project-pages/)
to see more detailed examples.

<div class="note warning">
  <h5>Source Files Must be in the Root Directory</h5>
  <p>
    GitHub Pages <a href="https://help.github.com/articles/troubleshooting-github-pages-build-failures#source-setting">overrides</a>
    the <a href="/docs/configuration/#global-configuration">“Site Source”</a>
    configuration value, so if you locate your files anywhere other than the
    root directory, your site may not build correctly.
  </p>
</div>

<div class="note">
  <h5>GitHub Pages Documentation, Help, and Support</h5>
  <p>
    For more information about what you can do with GitHub Pages, as well as for
    troubleshooting guides, you should check out
    <a href="https://help.github.com/categories/github-pages-basics/">GitHub’s Pages Help section</a>.
    If all else fails, you should contact <a href="https://github.com/contact">GitHub Support</a>.
  </p>
</div>
