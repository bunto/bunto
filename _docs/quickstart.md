---
layout: docs
title: Quick-start guide
permalink: /docs/quickstart/
---

For the impatient, here's how to get a boilerplate Bunto site up and running.

{% highlight bash %}
~ $ gem install bunto
~ $ bunto new myblog
~ $ cd myblog
~/myblog $ bunto serve
# => Now browse to http://localhost:4000
{% endhighlight %}

If you wish to install bunto into the current directory, you can do so by
alternatively running `bunto new .` instead of a new directory name.

That's nothing, though. The real magic happens when you start creating blog
posts, using the front matter to control templates and layouts, and taking
advantage of all the awesome configuration options Bunto makes available.

If you're running into problems, ensure you have all the [requirements
installed][Installation].

[Installation]: /docs/installation/
