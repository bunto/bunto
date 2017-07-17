---
title: Templates
permalink: /docs/templates/
---

Bunto uses the [Liquid](https://shopify.github.io/liquid/) templating language to
process templates. All of the standard Liquid [tags](https://shopify.github.io/liquid/tags/) and
[filters](https://shopify.github.io/liquid/filters/) are
supported. Bunto even adds a few handy filters and tags of its own to make
common tasks easier.

## Filters

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Description</th>
      <th><span class="filter">Filter</span> and <span class="output">Output</span></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p class="name"><strong>Relative URL</strong></p>
        <p>Prepend the <code>baseurl</code> value to the input. Useful if your site is hosted at a subpath rather than the root of the domain.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ "/assets/style.css" | relative_url }}{% endraw %}</code>
        </p>
        <p>
         <code class="output">/my-baseurl/assets/style.css</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Absolute URL</strong></p>
        <p>Prepend the <code>url</code> and <code>baseurl</code> value to the input.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ "/assets/style.css" | absolute_url }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">http://example.com/my-baseurl/assets/style.css</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Date to XML Schema</strong></p>
        <p>Convert a Date into XML Schema (ISO 8601) format.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.time | date_to_xmlschema }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">2008-11-07T13:07:54-08:00</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Date to RFC-822 Format</strong></p>
        <p>Convert a Date into the RFC-822 format used for RSS feeds.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.time | date_to_rfc822 }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">Mon, 07 Nov 2008 13:07:54 -0800</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Date to String</strong></p>
        <p>Convert a date to short format.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.time | date_to_string }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">07 Nov 2008</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Date to Long String</strong></p>
        <p>Format a date to long format.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.time | date_to_long_string }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">07 November 2008</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Where</strong></p>
        <p>Select all the objects in an array where the key has the given value.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.members | where:"graduation_year","2014" }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Where Expression</strong></p>
        <p>Select all the objects in an array where the expression is true. Bunto v3.2.0 & later.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.members | where_exp:"item",
"item.graduation_year == 2014" }}{% endraw %}</code>
         <code class="filter">{% raw %}{{ site.members | where_exp:"item",
"item.graduation_year < 2014" }}{% endraw %}</code>
         <code class="filter">{% raw %}{{ site.members | where_exp:"item",
"item.projects contains 'foo'" }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Group By</strong></p>
        <p>Group an array's items by a given property.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.members | group_by:"graduation_year" }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">[{"name"=>"2013", "items"=>[...]},
{"name"=>"2014", "items"=>[...]}]</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Group By Expression</strong></p>
        <p>Group an array's items using a Liquid expression.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.members | group_by_exp:"item",
"item.graduation_year | truncate: 3, \"\"" }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">[{"name"=>"201...", "items"=>[...]},
{"name"=>"200...", "items"=>[...]}]</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>XML Escape</strong></p>
        <p>Escape some text for use in XML.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ page.content | xml_escape }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>CGI Escape</strong></p>
        <p>
          CGI escape a string for use in a URL. Replaces any special characters
          with appropriate %XX replacements.
        </p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ "foo,bar;baz?" | cgi_escape }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">foo%2Cbar%3Bbaz%3F</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>URI Escape</strong></p>
        <p>
          URI escape a string.
        </p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ "foo, bar \baz?" | uri_escape }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">foo,%20bar%20%5Cbaz?</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Number of Words</strong></p>
        <p>Count the number of words in some text.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ page.content | number_of_words }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">1337</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Array to Sentence</strong></p>
        <p>Convert an array into a sentence. Useful for listing tags. Optional argument for connector.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ page.tags | array_to_sentence_string }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">foo, bar, and baz</code>
        </p>
        <p>
         <code class="filter">{% raw %}{{ page.tags | array_to_sentence_string: 'or' }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">foo, bar, or baz</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Markdownify</strong></p>
        <p>Convert a Markdown-formatted string into HTML.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ page.excerpt | markdownify }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Smartify</strong></p>
        <p>Convert "quotes" into &ldquo;smart quotes.&rdquo;</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ page.title | smartify }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Converting Sass/SCSS</strong></p>
        <p>Convert a Sass- or SCSS-formatted string into CSS.</p>
      </td>
      <td class="align-center">
        <p>
          <code class="filter">{% raw %}{{ some_scss | scssify }}{% endraw %}</code>
          <code class="filter">{% raw %}{{ some_sass | sassify }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Slugify</strong></p>
        <p>Convert a string into a lowercase URL "slug". See below for options.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ "The _config.yml file" | slugify }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">the-config-yml-file</code>
        </p>
        <p>
         <code class="filter">{% raw %}{{ "The _config.yml file" | slugify: 'pretty' }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">the-_config.yml-file</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Data To JSON</strong></p>
        <p>Convert Hash or Array to JSON.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.data.projects | jsonify }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Normalize Whitespace</strong></p>
        <p>Replace any occurrence of whitespace with a single space.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ "a \n b" | normalize_whitespace }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Sort</strong></p>
        <p>Sort an array. Optional arguments for hashes: 1.&nbsp;property name 2.&nbsp;nils order (<em>first</em> or <em>last</em>).</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ page.tags | sort }}{% endraw %}</code>
        </p>
        <p>
         <code class="filter">{% raw %}{{ site.posts | sort: 'author' }}{% endraw %}</code>
        </p>
        <p>
         <code class="filter">{% raw %}{{ site.pages | sort: 'title', 'last' }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Sample</strong></p>
        <p>Pick a random value from an array. Optional: pick multiple values.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ site.pages | sample }}{% endraw %}</code>
        </p>
        <p>
         <code class="filter">{% raw %}{{ site.pages | sample:2 }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>To Integer</strong></p>
        <p>Convert a string or boolean to integer.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ some_var | to_integer }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Array Filters</strong></p>
        <p>Push, pop, shift, and unshift elements from an Array.</p>
        <p>These are <strong>NON-DESTRUCTIVE</strong>, i.e. they do not mutate the array, but rather make a copy and mutate that.</p>
      </td>
      <td class="align-center">
        <p>
          <code class="filter">{% raw %}{{ page.tags | push: 'Spokane' }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">['Seattle', 'Tacoma', 'Spokane']</code>
        </p>
        <p>
          <code class="filter">{% raw %}{{ page.tags | pop }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">['Seattle']</code>
        </p>
        <p>
          <code class="filter">{% raw %}{{ page.tags | shift }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">['Tacoma']</code>
        </p>
        <p>
          <code class="filter">{% raw %}{{ page.tags | unshift: "Olympia" }}{% endraw %}</code>
        </p>
        <p>
          <code class="output">['Olympia', 'Seattle', 'Tacoma']</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class="name"><strong>Inspect</strong></p>
        <p>Convert an object into its String representation for debugging.</p>
      </td>
      <td class="align-center">
        <p>
         <code class="filter">{% raw %}{{ some_var | inspect }}{% endraw %}</code>
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>

### Options for the `slugify` filter

The `slugify` filter accepts an option, each specifying what to filter.
The default is `default`. They are as follows (with what they filter):

- `none`: no characters
- `raw`: spaces
- `default`: spaces and non-alphanumeric characters
- `pretty`: spaces and non-alphanumeric characters except for `._~!$&'()+,;=@`

## Tags

### Includes

If you have small page snippets that you want to include in multiple places on your site, save the snippets as *include files* and insert them where required, by using the `include` tag:

```liquid
{% raw %}{% include footer.html %}{% endraw %}
```

Bunto expects all *include files* to be placed in an `_includes` directory at the root of your source directory. In the above example, this will embed the contents of `_includes/footer.html` into the calling file.

For more advanced information on using includes, see [Includes](../includes).

### Code snippet highlighting

Bunto has built in support for syntax highlighting of over 60 languages
thanks to [Rouge](http://rouge.jneen.net). Rouge is the default highlighter
in Bunto 3 and above. To use it in Bunto 2, set `highlighter` to `rouge`
and ensure the `rouge` gem is installed properly.

Alternatively, you can use [Pygments](http://pygments.org) to highlight
your code snippets. To use Pygments, you must have Python installed on your
system, have the `pygments.rb` gem installed and set `highlighter` to
`pygments` in your site's configuration file. Pygments supports [over 100
languages](http://pygments.org/languages/)

To render a code block with syntax highlighting, surround your code as follows:

```liquid
{% raw %}
{% highlight ruby %}
def foo
  puts 'foo'
end
{% endhighlight %}
{% endraw %}
```

The argument to the `highlight` tag (`ruby` in the example above) is the
language identifier. To find the appropriate identifier to use for the language
you want to highlight, look for the “short name” on the [Rouge
wiki](https://github.com/jayferd/rouge/wiki/List-of-supported-languages-and-lexers)
or the [Pygments' Lexers page](http://pygments.org/docs/lexers/).

#### Line numbers

There is a second argument to `highlight` called `linenos` that is optional.
Including the `linenos` argument will force the highlighted code to include line
numbers. For instance, the following code block would include line numbers next
to each line:

```liquid
{% raw %}
{% highlight ruby linenos %}
def foo
  puts 'foo'
end
{% endhighlight %}
{% endraw %}
```

#### Stylesheets for syntax highlighting

In order for the highlighting to show up, you’ll need to include a highlighting
stylesheet. For an example stylesheet you can look at
[syntax.css](https://github.com/mojombo/tpw/tree/master/css/syntax.css). These
are the same styles as used by GitHub and you are free to use them for your own
site. If you use `linenos`, you might want to include an additional CSS class
definition for the `.lineno` class in `syntax.css` to distinguish the line
numbers from the highlighted code.

### Gist

Use the `gist` tag to easily embed a GitHub Gist onto your site. This works
with public or secret gists:

```liquid
{% raw %}
{% gist parkr/931c1c8d465a04042403 %}
{% endraw %}
```

You may also optionally specify the filename in the gist to display:

```liquid
{% raw %}
{% gist parkr/931c1c8d465a04042403 jekyll-private-gist.markdown %}
{% endraw %}
```

To use the `gist` tag, you'll need to add the
[bunto-gist](https://github.com/bunto/bunto-gist) gem to your project.

## Links

### Linking to pages {#link}

To link to a post, a page, collection item, or file, the `link` tag will generate the correct permalink URL for the path you specify. For example, if you use the `link` tag to link to `mypage.html`, even if you change your permalink style to include the file extension or omit it, the URL formed by the `link` tag will always be valid.

You must include the file's original extension when using the `link` tag. Here are some examples:

```liquid
{% raw %}
{{ site.baseurl }}{% link _collection/name-of-document.md %}
{{ site.baseurl }}{% link _posts/2016-07-26-name-of-post.md %}
{{ site.baseurl }}{% link news/index.html %}
{{ site.baseurl }}{% link /assets/files/doc.pdf %}
{% endraw %}
```

You can also use the `link` tag to create a link in Markdown as follows:

```liquid
{% raw %}
[Link to a document]({{ site.baseurl }}{% link _collection/name-of-document.md %})
[Link to a post]({{ site.baseurl }}{% link _posts/2016-07-26-name-of-post.md %})
[Link to a page]({{ site.baseurl }}{% link news/index.html %})
[Link to a file]({{ site.baseurl }}{% link /assets/files/doc.pdf %})
{% endraw %}
```

(Including `{% raw %}{{ site.baseurl }}{% endraw %}` is optional &mdash; it depends on whether you want to preface the page URL with the `baseurl` value.)

The path to the post, page, or collection is defined as the path relative to the root directory (where your config file is) to the file, not the path from your existing page to the other page.

For example, suppose you're creating a link `page_a.md` (stored in `pages/folder1/folder2`) to `page_b.md` (stored in  `pages/folder1`). Your path in the link would not be `../page_b.html`. Instead, it would be `/pages/folder1/page_b.md`.

If you're unsure of the path, add `{% raw %}{{ page.path }}{% endraw %}` to the page and it will display the path.

One major benefit of using the `link` tag is link validation. If the link doesn't exist, Bunto won't build your site. This is a good thing, as it will alert you to a broken link so you can fix it (rather than allowing you to build and deploy a site with broken links).

Note you cannot add filters to `link` tags. For example, you cannot append a string using Liquid filters, such as `{% raw %}{% link mypage.html | append: "#section1" %} {% endraw %}`. To link to sections on a page, you will need to use regular HTML or Markdown linking techniques.

### Linking to posts

If you want like to include a link to a post on your site, the `post_url` tag will generate the correct permalink URL for the post you specify.

```liquid
{% raw %}
{{ site.baseurl }}{% post_url 2010-07-21-name-of-post %}
{% endraw %}
```

If you organize your posts in subdirectories, you need to include subdirectory path to the post:

```liquid
{% raw %}
{{ site.baseurl }}{% post_url /subdir/2010-07-21-name-of-post %}
{% endraw %}
```

There is no need to include the file extension when using the `post_url` tag.

You can also use this tag to create a link to a post in Markdown as follows:

```liquid
{% raw %}
[Name of Link]({{ site.baseurl }}{% post_url 2010-07-21-name-of-post %})
{% endraw %}
```
