---
title: Basic Usage
permalink: /docs/usage/
---

The Bunto gem makes a `bunto` executable available to you in your Terminal
window. You can use this command in a number of ways:

```sh
$ bunto build
# => The current folder will be generated into ./_site

$ bunto build --destination <destination>
# => The current folder will be generated into <destination>

$ bunto build --source <source> --destination <destination>
# => The <source> folder will be generated into <destination>

$ bunto build --watch
# => The current folder will be generated into ./_site,
#    watched for changes, and regenerated automatically.
```

<div class="note info">
  <h5>Changes to _config.yml are not included during automatic regeneration.</h5>
  <p>
    The <code>_config.yml</code> master configuration file contains global configurations
    and variable definitions that are read once at execution time. Changes made to <code>_config.yml</code>
    during automatic regeneration are not loaded until the next execution.
  </p>
  <p>
    Note <a href="../datafiles">Data Files</a> are included and reloaded during automatic regeneration.
  </p>
</div>

<div class="note warning">
  <h5>Destination folders are cleaned on site builds</h5>
  <p>
    The contents of <code>&lt;destination&gt;</code> are automatically
    cleaned, by default, when the site is built. Files or folders that are not
    created by your site will be removed. Files and folders you wish to retain
    in <code>&lt;destination&gt;</code> may be specified within the <code>&lt;keep_files&gt;</code>
    configuration directive.
  </p>
  <p>
    Do not use an important location for <code>&lt;destination&gt;</code>;
    instead, use it as a staging area and copy files from there to your web server.
  </p>
</div>

Bunto also comes with a built-in development server that will allow you to
preview what the generated site will look like in your browser locally.

```sh
$ bunto serve
# => A development server will run at http://localhost:4000/
# Auto-regeneration: enabled. Use `--no-watch` to disable.

$ bunto serve --detach
# => Same as `bunto serve` but will detach from the current terminal.
#    If you need to kill the server, you can `kill -9 1234` where "1234" is the PID.
#    If you cannot find the PID, then do, `ps aux | grep bunto` and kill the instance.
```

<div class="note info">
  <h5>Be aware of default behavior</h5>
  <p>
    As of version 2.4, the <code>serve</code> command will watch for changes automatically. To disable this, you can use <code>bunto serve --no-watch</code>, which preserves the old behavior.
  </p>
</div>

```sh
$ bunto serve --no-watch
# => Same as `bunto serve` but will not watch for changes.
```

These are just a few of the available [configuration options](../configuration/).
Many configuration options can either be specified as flags on the command line,
or alternatively (and more commonly) they can be specified in a `_config.yml`
file at the root of the source directory. Bunto will automatically use the
options from this file when run. For example, if you place the following lines
in your `_config.yml` file:

```yaml
source:      _source
destination: _deploy
```

Then the following two commands will be equivalent:

```sh
$ bunto build
$ bunto build --source _source --destination _deploy
```

For more about the possible configuration options, see the
[configuration](../configuration/) page.

<div class="note info">
  <h5>Call for help</h5>
  <p>
    The <code>help</code> command is always here to remind you of all available options and usage, and also works with the <code>build</code>, <code>serve</code> and <code>new</code> subcommands, e.g <code>bunto help new</code> or <code>bunto help build</code>.
  </p>
</div>

If you're interested in browsing these docs on-the-go, install the
`bunto-docs` gem and run `bunto docs` in your terminal.
