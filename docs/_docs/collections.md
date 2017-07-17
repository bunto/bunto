---
title: Collections
permalink: /docs/collections/
---

Not everything is a post or a page. Maybe you want to document the various
methods in your open source project, members of a team, or talks at a
conference. Collections allow you to define a new type of document that behave
like Pages or Posts do normally, but also have their own unique properties and
namespace.

## Using Collections

To start using collections, follow these 3 steps:

* [Step 1: Tell Bunto to read in your collection](#step1)
* [Step 2: Add your content](#step2)
* [Step 3: Optionally render your collection's documents into independent files](#step3)

### Step 1: Tell Bunto to read in your collection {#step1}

Add the following to your site's `_config.yml` file, replacing `my_collection`
with the name of your collection:

```yaml
collections:
- my_collection
```

You can optionally specify metadata for your collection in the configuration:

```yaml
collections:
  my_collection:
    foo: bar
```

Default attributes can also be set for a collection:

```yaml
defaults:
  - scope:
      path: ""
      type: my_collection
    values:
      layout: page
```

### Step 2: Add your content {#step2}

Create a corresponding folder (e.g. `<source>/_my_collection`) and add
documents. YAML front matter is processed if the front matter exists, and everything
after the front matter is pushed into the document's `content` attribute. If no YAML front
matter is provided, Bunto will not generate the file in your collection.

<div class="note info">
  <h5>Be sure to name your directories correctly</h5>
  <p>
The folder must be named identically to the collection you defined in
your <code>_config.yml</code> file, with the addition of the preceding <code>_</code> character.
  </p>
</div>

### Step 3: Optionally render your collection's documents into independent files {#step3}

If you'd like Bunto to create a public-facing, rendered version of each
document in your collection, set the `output` key to `true` in your collection
metadata in your `_config.yml`:

```yaml
collections:
  my_collection:
    output: true
```

This will produce a file for each document in the collection.
For example, if you have `_my_collection/some_subdir/some_doc.md`,
it will be rendered using Liquid and the Markdown converter of your
choice and written out to `<dest>/my_collection/some_subdir/some_doc.html`.

<div class="note info">
  <h5>Don't forget to add YAML for processing</h5>
  <p>
  Files in collections that do not have front matter are treated as
  <a href="/docs/static-files">static files</a> and simply copied to their
  output location without processing.
  </p>
</div>

## Configuring permalinks for collections {#permalinks}

You can customize the [Permalinks](../permalinks/) for your collection's documents by setting `permalink` property in the collection's configuration as follows:

```yaml
collections:
  my_collection:
    output: true
    permalink: /awesome/:path/:title.:output_ext
```

In this example, the collection documents will the have the URL of `awesome` followed by the path to the document and its file extension.

Collections have the following template variables available for permalinks:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>collection</code></p>
      </td>
      <td>
        <p>Label of the containing collection.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>path</code></p>
      </td>
      <td>
        <p>Path to the document relative to the collection's directory.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>name</code></p>
      </td>
      <td>
        <p>The document's base filename, with every sequence of spaces
        and non-alphanumeric characters replaced by a hyphen.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>title</code></p>
      </td>
      <td>
        <p>The document's lowercase title (as defined in its <a href="/docs/frontmatter/">front matter</a>), with every sequence of spaces and non-alphanumeric characters replaced by a hyphen. If the document does not define a title in its <a href="/docs/frontmatter/">front matter</a>, this is equivalent to <code>name</code>.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>output_ext</code></p>
      </td>
      <td>
        <p>Extension of the output file.</p>
      </td>
    </tr>
  </tbody>
</table>
</div>

## Permalink examples for collections

Depending on how you declare the permalinks in your configuration file, the permalinks and paths get written differently in the `_site` folder. A few examples will help clarify the options.

Let's say your collection is called `apidocs` with `doc1.md` in your collection. `doc1.md` is grouped inside a folder called `mydocs`. Your project's source directory for the collection looks this:

```
├── \_apidocs
│   └── mydocs
│       └── doc1.md
```

Based on this scenario, here are a few permalink options.

**Permalink configuration 1**: [Nothing configured] <br/>
**Output**:

```
├── apidocs
│   └── mydocs
│       └── doc1.html
```

**Permalink configuration 2**: `/:collection/:path/:title:output_ext`  <br/>
**Output**:

```
├── apidocs
│   └── mydocs
│       └── doc1.html
```

**Permalink configuration 3**: No collection permalinks configured, but `pretty` configured for pages/posts. <br/>
**Output**:

```
├── apidocs
│   └── mydocs
│       └── doc1
│           └── index.html
```

**Permalink configuration 4**: `/awesome/:path/:title.html`   <br/>
**Output**:

```
├── awesome
│   └── mydocs
│       └── doc1.html
```

**Permalink configuration 5**: `/awesome/:path/:title/`  <br/>
**Output**:

```
├── awesome
│   └── mydocs
│       └── doc1
│           └── index.html
```

**Permalink configuration 6**: `/awesome/:title.html` <br/>
**Output**:  

```
├── awesome
│   └── doc1.html
```

**Permalink configuration 7**: `:title.html`
**Output**:

```
├── doc1.html
```

## Liquid Attributes

### Collections

Each collection is accessible as a field on the `site` variable. For example, if
you want to access the `albums` collection found in `_albums`, you'd use
`site.albums`. 

Each collection is itself an array of documents (e.g., `site.albums` is an array of documents, much like `site.pages` and
`site.posts`). See the table below for how to access attributes of those documents.

The collections are also available under `site.collections`, with the metadata
you specified in your `_config.yml` (if present) and the following information:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>label</code></p>
      </td>
      <td>
        <p>
          The name of your collection, e.g. <code>my_collection</code>.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>docs</code></p>
      </td>
      <td>
        <p>
          An array of <a href="#documents">documents</a>.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>files</code></p>
      </td>
      <td>
        <p>
          An array of static files in the collection.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>relative_directory</code></p>
      </td>
      <td>
        <p>
          The path to the collection's source directory, relative to the site
          source.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>directory</code></p>
      </td>
      <td>
        <p>
          The full path to the collections's source directory.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>output</code></p>
      </td>
      <td>
        <p>
          Whether the collection's documents will be output as individual
          files.
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>


### Documents

In addition to any YAML Front Matter provided in the document's corresponding
file, each document has the following attributes:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>content</code></p>
      </td>
      <td>
        <p>
          The (unrendered) content of the document. If no YAML Front Matter is
          provided, Bunto will not generate the file in your collection. If
          YAML Front Matter is used, then this is all the contents of the file
          after the terminating
          `---` of the front matter.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>output</code></p>
      </td>
      <td>
        <p>
          The rendered output of the document, based on the
          <code>content</code>.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>path</code></p>
      </td>
      <td>
        <p>
          The full path to the document's source file.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>relative_path</code></p>
      </td>
      <td>
        <p>
          The path to the document's source file relative to the site source.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>url</code></p>
      </td>
      <td>
        <p>
          The URL of the rendered collection. The file is only written to the destination when the collection to which it belongs has <code>output: true</code> in the site's configuration.
          </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>collection</code></p>
      </td>
      <td>
        <p>
          The name of the document's collection.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>date</code></p>
      </td>
      <td>
        <p>
          The date of the document's collection.
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>

## Accessing Collection Attributes

Attributes from the YAML front matter can be accessed as data anywhere in the
site. Using the above example for configuring a collection as `site.albums`,
you might have front matter in an individual file structured as follows (which
must use a supported markup format, and cannot be saved with a `.yaml`
extension):

```yaml
title: "Josquin: Missa De beata virgine and Missa Ave maris stella"
artist: "The Tallis Scholars"
director: "Peter Phillips"
works:
  - title: "Missa De beata virgine"
    composer: "Josquin des Prez"
    tracks:
      - title: "Kyrie"
        duration: "4:25"
      - title: "Gloria"
        duration: "9:53"
      - title: "Credo"
        duration: "9:09"
      - title: "Sanctus & Benedictus"
        duration: "7:47"
      - title: "Agnus Dei I, II & III"
        duration: "6:49"
```

Every album in the collection could be listed on a single page with a template:

```html
{% raw %}
{% for album in site.albums %}
  <h2>{{ album.title }}</h2>
  <p>Performed by {{ album.artist }}{% if album.director %}, directed by {{ album.director }}{% endif %}</p>
  {% for work in album.works %}
    <h3>{{ work.title }}</h3>
    <p>Composed by {{ work.composer }}</p>
    <ul>
    {% for track in work.tracks %}
      <li>{{ track.title }} ({{ track.duration }})</li>
    {% endfor %}
    </ul>
  {% endfor %}
{% endfor %}
{% endraw %}
```
