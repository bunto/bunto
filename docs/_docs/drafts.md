---
title: Working with drafts
permalink: /docs/drafts/
---

Drafts are posts without a date. They're posts you're still working on and
don't want to publish yet. To get up and running with drafts, create a
`_drafts` folder in your site's root (as described in the [site structure](/docs/structure/) section) and create your
first draft:

```text
|-- _drafts/
|   |-- a-draft-post.md
```

To preview your site with drafts, simply run `bunto serve` or `bunto build`
with the `--drafts` switch. Each will be assigned the value modification time
of the draft file for its date, and thus you will see currently edited drafts
as the latest posts.
