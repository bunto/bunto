---
title: Troubleshooting
permalink: /docs/troubleshooting/
---

If you ever run into problems installing or using Bunto, here are a few tips
that might be of help. If the problem you’re experiencing isn’t covered below,
**please [check out our other help resources](/help/)** as well.

- [Installation Problems](#installation-problems)
- [Problems running Bunto](#problems-running-bunto)
- [Base-URL Problems](#base-url-problems)
- [Configuration problems](#configuration-problems)
- [Markup Problems](#markup-problems)
- [Production Problems](#production-problems)

## Installation Problems

If you encounter errors during gem installation, you may need to install
the header files for compiling extension modules for Ruby 2.0.0. This
can be done on Ubuntu or Debian by running:

```sh
sudo apt-get install ruby2.3-dev
```

On Red Hat, CentOS, and Fedora systems you can do this by running:

```sh
sudo yum install ruby-devel
```

If you installed the above - specifically on Fedora 23 - but the extensions would still not compile, you are probably running a Fedora image that misses the `redhat-rpm-config` package. To solve this, simply run:

```sh
sudo dnf install redhat-rpm-config
```


On [NearlyFreeSpeech](https://www.nearlyfreespeech.net/) you need to run the
following commands before installing Bunto:

```sh
export GEM_HOME=/home/private/gems
export GEM_PATH=/home/private/gems:/usr/local/lib/ruby/gems/1.8/
export PATH=$PATH:/home/private/gems/bin
export RB_USER_INSTALL='true'
```

To install RubyGems on Gentoo:

```sh
sudo emerge -av dev-ruby/rubygems
```

On Windows, you may need to install [RubyInstaller
DevKit](https://wiki.github.com/oneclick/rubyinstaller/development-kit).

On macOS, you may need to update RubyGems (using `sudo` only if necessary):

```sh
sudo gem update --system
```

If you still have issues, you can download and install new Command Line
Tools (such as `gcc`) using the following command:

```sh
xcode-select --install
```

which may allow you to install native gems using this command (again using
`sudo` only if necessary):

```sh
sudo gem install bunto
```

Note that upgrading macOS does not automatically upgrade Xcode itself
(that can be done separately via the App Store), and having an out-of-date
Xcode.app can interfere with the command line tools downloaded above. If
you run into this issue, upgrade Xcode and install the upgraded Command
Line Tools.

### Bunto &amp; Mac OS X 10.11

With the introduction of System Integrity Protection, several directories
that were previously writable are now considered system locations and are no
longer available. Given these changes, there are a couple of simple ways to get
up and running. One option is to change the location where the gem will be
installed (again using `sudo` only if necessary):

```sh
sudo gem install -n /usr/local/bin bunto
```

Alternatively, Homebrew can be installed and used to set up Ruby. This can be
done as follows:

```sh
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Once Homebrew is installed, the second step is easy:

```sh
brew install ruby
```

Advanced users (with more complex needs) may find it helpful to choose one of a
number of Ruby version managers ([RVM][], [rbenv][], [chruby][], [etc][].) in
which to install Bunto.

[RVM]: https://rvm.io
[rbenv]: http://rbenv.org
[chruby]: https://github.com/postmodern/chruby
[etc]: https://github.com/rvm/rvm/blob/master/docs/alt.md

If you elect to use one of the above methods to install Ruby, it might be
necessary to modify your `$PATH` variable using the following command:

```sh
export PATH=/usr/local/bin:$PATH
```

GUI apps can modify the `$PATH` as follows:

```sh
launchctl setenv PATH "/usr/local/bin:$PATH"
```

Either of these approaches are useful because `/usr/local` is considered a
"safe" location on systems which have SIP enabled, they avoid potential
conflicts with the version of Ruby included by Apple, and it keeps Bunto and
its dependencies in a sandboxed environment. This also has the added
benefit of not requiring `sudo` when you want to add or remove a gem.

### Could not find a JavaScript runtime. (ExecJS::RuntimeUnavailable)

This error can occur during the installation of `bunto-coffeescript` when
you don't have a proper JavaScript runtime. To solve this, either install
`execjs` and `therubyracer` gems, or install `nodejs`. Check out
[issue #2327](https://github.com/bunto/bunto/issues/2327) for more info.

## Problems running Bunto

On Debian or Ubuntu, you may need to add `/var/lib/gems/1.8/bin/` to your path
in order to have the `bunto` executable be available in your Terminal.

## Base-URL Problems

If you are using base-url option like:

```sh
bunto serve --baseurl '/blog'
```

… then make sure that you access the site at:

```sh
http://localhost:4000/blog/index.html
```

It won’t work to just access:

```sh
http://localhost:4000/blog
```

## Configuration problems

The order of precedence for conflicting [configuration settings](../configuration/)
is as follows:

1. Command-line flags
2. Configuration file settings
3. Defaults

That is: defaults are overridden by options specified in `_config.yml`,
and flags specified at the command-line will override all other settings
specified elsewhere.

If you encounter an error in building the site, with the error message 
"'0000-00-00-welcome-to-bunto.markdown.erb' does not have a valid date in the 
YAML front matter." try including the line `exclude: [vendor]` 
in `_config.yml`. 

## Markup Problems

The various markup engines that Bunto uses may have some issues. This
page will document them to help others who may run into the same
problems.

### Liquid

The latest version, version 2.0, seems to break the use of `{{ "{{" }}` in
templates. Unlike previous versions, using `{{ "{{" }}` in 2.0 triggers the
following error:

```sh
'{{ "{{" }}' was not properly terminated with regexp: /\}\}/  (Liquid::SyntaxError)
```

### Excerpts

Since v1.0.0, Bunto has had automatically-generated post excerpts. Since
v1.1.0, Bunto also passes these excerpts through Liquid, which can cause
strange errors where references don't exist or a tag hasn't been closed. If you
run into these errors, try setting `excerpt_separator: ""` in your
`_config.yml`, or set it to some nonsense string.

## Production Problems

If you run into an issue that a static file can't be found in your
production environment during build since v3.2.0 you should set your
[environment to `production`](../configuration/#specifying-a-bunto-environment-at-build-time).
The issue is caused by trying to copy a non-existing symlink.

<div class="note">
  <h5>Please report issues you encounter!</h5>
  <p>
  If you come across a bug, please <a href="{{ site.help_url }}/issues/new">create an issue</a>
  on GitHub describing the problem and any work-arounds you find so we can
  document it here for others.
  </p>
</div>
