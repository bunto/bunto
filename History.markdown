## HEAD
> The history log of the Bunto project. See all commits in https://github.com/bunto/bunto/commits/ruby!

----

### Minor Enhancements
* Move bin/bunto to exe/bunto to prevent collision with binstubs (#78)
* Run Site#generate for 'bunto doctor' to catch plugin issues (#82)

### Development Fixes
* Fix rubocop offenses in exe/bunto (#79)
* Rubocop: test/* (#80)

### Site Enhancements
* Update normalize.css to v4.0.0. (#81)
* Update template links to point to core Liquid site (#83)

## 3.0.0 / 2016-0?-??

### Minor Enhancements

  * Deprecate access to Document#data properties and Collection#docs methods
  * Sort static files just once, and call `site_payload` once for all collections
  * Separate `bunto docs` and optimize external gem handling
  * Improve `Site#getConverterImpl` and call it `Site#find_converter_instance`
  * Use relative path for `path` Liquid variable in Documents for consistency
  * Generalize `Utils#slugify` for any scripts
  * Added basic microdata to post template in site template
  * Store log messages in an array of messages.
  * Allow collection documents to override `output` property in front matter
  * Keep file modification times between builds for static files
  * Only downcase mixed-case categories for the URL
  * Added per post `excerpt_separator` functionality
  * Allow collections YAML to end with three dots
  * Add mode parameter to `slugify` Liquid filter
  * Perf: `Markdown#matches` should avoid regexp
  * Perf: Use frozen regular expressions for `Utils#slugify`
  * Split off Textile support into bunto-textile-converter
  * Improve the navigation menu alignment in the site template on small screens
  * Show the regeneration time after the initial generation
  * Site template: Switch default font to Helvetica Neue
  * Make the `include` tag a teensy bit faster.
  * Add `pkill -f bunto` to ways to kill.
  * Site template: collapsed, variable-driven font declaration
  * Site template: Don't always show the scrollbar in code blocks
  * Site template: Remove undefined `text` class from `p` element
  * Site template: Optimize text rendering for legibility
  * Add `draft?` method to identify if Post is a Draft & expose to Liquid
  * Write regeneration metadata even on full rebuild
  * Perf: Use `String#end_with?("/")` instead of regexp when checking paths
  * Docs: document 'ordinal' built-in permalink style
  * Upgrade liquid-c to 3.x
  * Use consistent syntax for deprecation warning
  * Added build --destination and --source flags
  * Site template: remove unused `page.meta` attribute
  * Improve the error message when sorting null objects
  * Added liquid-md5 plugin
  * Documentation: RR replaced with RSpec Mocks
  * Documentation: Fix subpath.
  * Create 'tmp' dir for test_tags if it doesn't exist
  * Extract reading of data from `Site` to reduce responsibilities.
  * Removed the word 'Bunto' a few times from the comments
  * `bin/bunto`: with no args, exit with exit code 1
  * Incremental build if destination file missing
  * Static files `mtime` liquid should return a `Time` obj
  * Use `Bunto::Post`s for both LSI indexing and lookup.
  * Add `charset=utf-8` for HTML and XML pages in WEBrick
  * Set log level to debug when verbose flag is set
  * Added a mention on the Gemfile to complete the instructions
  * Perf: Cache `Document#to_liquid` and invalidate where necessary
  * Perf: `Bunto::Cleaner#existing_files`: Call `keep_file_regex` and `keep_dirs` only once, not once per iteration
  * Omit bunto/bunto-help from list of resources.
  * Add basic `bunto doctor` test to detect fsnotify (OSX) anomalies.
  * Added bunto.github.io/talk/ to "Have questions?"
  * Performance: Sort files only once
  * Performance: Marshal metadata
  * Upgrade highlight wrapper from `div` to `figure`
  * Upgrade mime-types to `~> 2.6`
  * Update windows.md with Ruby version info
  * Make the directory for includes configurable
  * Rename directory configurations to match `*_dir` convention for consistency
  * Internal: trigger hooks by owner symbol
  * Update MIME types from mime-db
  * Add header to site template `_config.yml` for clarity & direction
  * Site template: add timezone offset to post date frontmatter
  * Make a constant for the regex to find hidden files
  * Site template: refactor github & twitter icons into includes
  * Site template: add background to Kramdown Rouge-ified backtick code blocks
  * Include `.rubocop.yml` in Gem
  * `LiquidRenderer#parse`: parse with line numbers.
  * Add consistency to the no-subcommand deprecation message
  * Use `Liquid::Drop`s instead of `Hash`es in `#to_liquid`
  * Add 'sample' Liquid filter Equivalent to Array#sample functionality
  * Cache parsed include file to save liquid parsing time.
  * Slightly speed up url sanitization and handle multiples of ///.
  * Print debug message when a document is skipped from reading
  * Include tag should accept multiple variables in the include name
  * Add `-o` option to serve command which opens server URL
  * Add CodeClimate platform for better code quality.
  * General improvements for WEBrick via bunto serve such as SSL & custom headers
  * Add a default charset to content-type on webrick.
  * Switch `PluginManager` to use `require_with_graceful_fail` for better UX
  * Allow quoted date in front matter defaults
  * Add a Bunto doctor warning for URLs that only differ by case
  * drops: create one base Drop class which can be set as mutable or not
  * drops: provide `#to_h` to allow for hash introspection
  * Shim subcommands with indication of gem possibly required so users know how to use them
  * Add smartify Liquid filter for SmartyPants
  * Raise error on empty permalink
  * Refactor Page#permalink method
  * Stop testing with Ruby 2.0.x, which is EOL'd.
  * Allow collections to have documents that have no file extension
  * Add size property to group_by result
  * Site Template: Removed unnecessary nesting from `_base.scss`
  * Adding a debug log statment for skipped future documents.
  * Site Template: Changed main `<div>` to `<main>` and added accessibility info
  * Add array support to `where` filter
  * 'bunto clean': also remove .sass-cache
  * Clean up Tags::PostUrl a bit, including better errors and date parsing
  * Use String#encode for xml_escape filter instead of CGI.escapeHTML
  * Add show_dir_listing option for serve command and fix index file names
  * Site Template: write a Gemfile which is educational to the new site
  * Site template: add explanation of site variables in the example `_config.yml`
  * Adds `link` Liquid tag to make generation of URL's easier
  * Allow static files to be symlinked in unsafe mode or non-prod environments
  * Add `:after_init` hook & add `Site#config=` to make resetting config easy
  * DocumentDrop: add `#<=>` which sorts by date (falling back to path)
  * Add a where_exp filter for filtering by expression
  * Globalize Bunto's Filters.
  * Gem-based themes
  * Allow symlinks if they point to stuff inside site.source
  * Update colorator dependency to v1.x

### Major Enhancements

  * Fix defaults for Documents to lookup defaults based on `relative_path` instead of `url`
  * Use SSLEnable instead of EnableSSL and make URL HTTPS (WEBrick)
  * Liquid profiler (i.e. know how fast or slow your templates render)
  * Incremental regeneration
  * Add Hooks: a new kind of plugin
  * Upgrade to Liquid 3.0.0
  * `site.posts` is now a Collection instead of an Array
  * Add basic support for JRuby
  * Drop support for Ruby 1.9.3.
  * Support Ruby v2.2
  * Support RDiscount 2
  * Remove most runtime deps
  * Move to Rouge as default highlighter
  * Mimic GitHub Pages `.html` extension stripping behavior in WEBrick
  * Always include file extension on output files
  * Improved permalinks for pages and collections
  * Remove support for relative permalinks
  * Iterate over `site.collections` as an array instead of a hash.
  * Adapt StaticFile for collections, config defaults
  * Add a Code of Conduct for the Bunto project
  * Added permalink time variables
  * Add `--incremental` flag to enable incremental regen (disabled by default)

### Bug Fixes

  * `post_url`: fix access deprecation warning & fix deprecation msg
  * Perform bunto-paginate deprecation warning correctly.
  * Make permalink parsing consistent with pages
  * `time()`pre-filter method should accept a `Date` object
  * Remove unneeded end tag for `link` in site template
  * Kramdown: Use `enable_coderay` key instead of `use_coderay`
  * Unescape `Document` output path
  * Fix nav items alignment when on multiple rows
  * Highlight: Only Strip Newlines/Carriage Returns, not Spaces
  * Find variables in front matter defaults by searching with relative file path.
  * Allow variables (e.g `:categories`) in YAML front matter permalinks
  * Handle nil URL placeholders in permalinks
  * Template: Fix nav items alignment when in "burger" mode
  * Template: Remove `!important` from nav SCSS
  * The `:title` URL placeholder for collections should be the filename slug.
  * Trim the generate time diff to just 3 places past the decimal place
  * The highlight tag should only clip the newlines before and after the *entire* block, not in between
  * highlight: fix problem with linenos and rouge.
  * `Site#read_data_file`: read CSV's with proper file encoding
  * Ignore `.bunto-metadata` in site template
  * Template: Point documentation link to the documentation page
  * Removed the trailing slash from the example `/blog` baseurl comment
  * Clear the regenerator cache every time we process
  * Readd (bring back) minitest-profile
  * Add WOFF2 font MIME type to Bunto server MIME types
  * Be smarter about extracting the extname in `StaticFile`
  * Process metadata for all dependencies
  * Show error message if the YAML front matter on a page/post is invalid.
  * Upgrade redcarpet to 3.2 (Security fix: OSVDB-120415)
  * Create #mock_expects that goes directly to RSpec Mocks.
  * Open `.bunto-metadata` in binary mode to read binary Marshal data
  * Incremental regeneration: handle deleted, renamed, and moved dependencies
  * Fix typo on line 19 of pagination.md
  * Fix it so that 'blog.html' matches 'blog.html'
  * Remove occasionally-problematic `ensure` in `LiquidRenderer`
  * Fixed an unclear code comment in site template SCSS
  * Fix reading of binary metadata file
  * Remove var collision with site template header menu iteration variable
  * Change non-existent `hl_linenos` to `hl_lines` to allow passthrough in safe mode
  * Add missing flag to disable the watcher
  * Update CI guide to include more direct explanations of the flow
  * Set `future` to `false` in the default config
  * filters: `where` should compare stringified versions of input & comparator
  * Read build options for `bunto clean` command
  * Fix #3970: Use Gem::Version to compare versions, not `>`.
  * Abort if no subcommand. Fixes confusing message.
  * Whole-post excerpts should match the post content
  * Change default font weight to 400 to fix bold/strong text issues
  * Document: Only auto-generate the excerpt if it's not overridden
  * Utils: `deep_merge_hashes` should also merge `default_proc`
  * Defaults: compare paths in `applies_path?` as `String`s to avoid confusion
  * When checking a Markdown extname, include position of the `.`
  * Fix `jsonify` Liquid filter handling of boolean values
  * Add comma to value of `viewport` meta tag
  * Set the link type for the RSS feed to `application/rss+xml`
  * Refactor `#as_liquid`
  * Fix extension weirdness with folders
  * EntryFilter: only include 'excluded' log on excluded files
  * `Bunto.sanitized_path`: escape tildes before sanitizing a questionable path
  * `LiquidRenderer#parse`: parse with line numbers
  * `Document#<=>`: protect against nil comparison in dates.
  * Document: throw a useful error when an invalid date is given
  * Document: only superdirectories of the collection are categories
  * `Convertible#render_liquid` should use `render!` to cause failure on bad Liquid
  * Don't generate `.bunto-metadata` in non-incremental build
  * Set `highlighter` config val to `kramdown.syntax_highlighter`
  * Align hooks implementation with documentation
  * Fix the deprecation warning in the doctor command
  * Fix case in `:title` and add `:slug` which is downcased
  * `Page#dir`: ensure it ends in a slash
  * Add `Utils.merged_file_read_opts` to unify reading & strip the BOM
  * `Renderer#output_ext`: honor folders when looking for ext
  * Pass build options into `clean` command
  * Allow users to use .htm and .xhtml (XHTML5.)
  * Prevent Shell Injection.
  * Convertible should make layout data accessible via `layout` instead of `page`
  * Avoid using `Dir.glob` with absolute path to allow special characters in the path
  * Handle empty config files
  * Rename `@options` so that it does not impact Liquid.
  * utils/drops: update Drop to support `Utils.deep_merge_hashes`
  * Make sure bunto/drops/drop is loaded first.
  * Convertible/Page/Renderer: use payload hash accessor & setter syntax for backwards-compatibility
  * Drop: fix hash setter precendence
  * utils: `has_yaml_header?` should accept files with extraneous spaces
  * Escape html from site.title and page.title in site template
  * Allow custom file extensions if defined in `permalink` YAML front matter
  * Fix deep_merge_hashes! handling of drops and hashes
  * Page should respect output extension of its permalink
  * Disable auto-regeneration when running server detached
  * Drop#[]: only use public_send for keys in the content_methods array
  * Extract title from filename successfully when no date.
  * Site Template: Added a default lang attribute
  * Site template: Escape title and description where it is used in HTML
  * Document#date: drafts which have no date should use source file mtime
  * Filters#time: clone an input Time so as to be non-destructive
  * Doctor: fix issue where `--config` wasn't a recognized flag
  * Ensures related_posts are only set for a post
  * EntryFilter#special?: ignore filenames which begin with '~'
  * Cleaner: `keep_files` should only apply to the beginning of paths, not substrings with index > 0
  * Use SSLEnable instead of EnableSSL and make URL HTTPS.
  * convertible: use Document::YAML_FRONT_MATTER_REGEXP to parse transformable files
  * Example in the site template should be IANA-approved example.com
  * 3.2.x/master: Fix defaults for Documents (posts/collection docs)
  * Don't rescue LoadError or bundler load errors for Bundler.
  * Fix syntax highlighting in kramdown by making `@config` accessible in the Markdown converter.
  * `Bunto.sanitized_path`: sanitizing a questionable path should handle tildes
  * Fix `titleize` so already capitalized words are not dropped
  * Permalinks which end in a slash should always output HTML

### Development Fixes

  * Remove call to `#backwards_compatibilize` in `Configuration.from`
  * Fix defaults for Documents to lookup defaults based on `relative_path` instead of `url`
  * Configuration: allow users to specify a `collections.posts.permalink` directly without `permalink` clobbering it
  * Fix test warnings when doing rake {test,spec} or script/test
  * Remove loader.rb and "modernize" `script/test`.
  * Improve the grammar in the documentation
  * Update the LICENSE text to match the MIT license exactly
  * Update rake task `site:publish` to fix minor bugs.
  * Switch to shields.io for the README badges.
  * Use `FileList` instead of `Dir.glob` in `site:publish` rake task
  * Fix test script to be platform-independent
  * Instead of symlinking `/tmp`, create and symlink a local `tmp` in the tests
  * Fix some spacing
  * Fix comment typo in `lib/bunto/frontmatter_defaults.rb`
  * Move all `regenerate?` checking to `Regenerator`
  * Factor out a `read_data_file` call to keep things clean
  * Proof the site with CircleCI.
  * Update LICENSE to 2015.
  * Upgrade tests to use Minitest
  * Remove trailing whitespace
  * Use `fixture_site` for Document tests
  * Remove adapters deprecation warning
  * Minor fixes to `url.rb` to follow GitHub style guide
  * Minor changes to resolve deprecation warnings
  * Convert remaining textile test documents to markdown
  * Migrate the tests to use rspec-mocks
  * Remove `activesupport`
  * Added tests for `Bunto:StaticFile`
  * Force minitest version to 5.5.1
  * Update the way cucumber accesses Minitest assertions
  * Add `script/rubyprof` to generate cachegrind callgraphs
  * Upgrade cucumber to 2.x
  * Update Kramdown.
  * Updated the scripts shebang for portability
  * Update JRuby testing to 9K
  * Organize dependencies into dev and test groups.
  * Contributing.md should refer to `script/cucumber`
  * Update contributing documentation to reflect workflow updates
  * Add script to vendor mime types
  * Ignore .bundle dir in SimpleCov
  * `bunto-docs` should be easily release-able
  * Allow use of Cucumber 2.1 or greater
  * Modernize Kramdown for Markdown converter.
  * Change TestDoctorCommand to BuntoUnitTest...
  * Create namespaced rake tasks in separate `.rake` files under `lib/tasks`
  * markdown: refactor for greater readability & efficiency
  * Fix many Rubocop style errors
  * Fix spelling of "GitHub" in docs and history
  * Reorganize and cleanup the Gemfile, shorten required depends.
  * Remove script/rebund.
  * Implement codeclimate platform
  * Remove ObectSpace dumping and start using inherited, it's faster.
  * Add script/travis so all people can play with Travis-CI images.
  * Move Cucumber to using RSpec-Expections and furthering JRuby support.
  * Rearrange Cucumber and add some flair.
  * Remove old FIXME
  * Clean up the Gemfile (and keep all the necessary dependencies)
  * Require at least cucumber version 2.1.0
  * Suppress stdout in liquid profiling test
  * Exclude built-in bundles from being added to coverage report
  * Add project maintainer profile links
  * Fix state leakage in Kramdown test
  * Unify method for copying special files from repo to site
  * Refresh the contributing file
  * change smartify doc from copy/paste of mardownify doc
  * Update Rake & disable warnings when running tests
  * Fix many warnings
  * Don't blindly assume the last system when determining "open" cmd
  * Fix "locally" typo in contributing documentation

### Site Enhancements

  * Add 'info' labels to certain notes in collections docs
  * Remove extra spaces, make the last sentence less awkward in permalink docs
  * Update the permalinks documentation to reflect the updates for 3.0
  * Add blog post announcing Bunto Help
  * Add Bunto Talk to Help page on site
  * Change Ajax pagination resource link to use HTTPS
  * Fixing the default host on docs
  * Add `bunto-thumbnail-filter` to list of third-party plugins
  * Add link to 'Adding Ajax pagination to Bunto' to Resources page
  * Add a Resources link to tutorial on building dynamic navbars
  * Semantic structure improvements to the post and page layouts
  * Add new AsciiDoc plugin to list of third-party plugins.
  * Specify that all transformable collection documents must contain YAML front matter
  * Assorted accessibility fixes
  * Update configuration docs to mention `keep_files` for `destination`
  * Break when we successfully generate nav link to save CPU cycles.
  * Update usage docs to mention `keep_files` and a warning about `destination` cleaning
  * Add logic to automatically generate the `next_section` and `prev_section` navigation items
  * Some small fixes for the Plugins TOC.
  * Added versioning comment to configuration file
  * Add `bunto-minifier` to list of third-party plugins
  * Add blog post about the Bunto meet-up
  * Use `highlight` Liquid tag instead of the four-space tabs for code
  * 3.0.0.beta1 release post
  * Add `twa` to the list of third-party plugins
  * Remove extra spaces
  * Fix small grammar errors on a couple pages
  * Fix typo on Templates docs page
  * s/three/four for plugin type list
  * Release bunto.github.io as a locally-compiled site.
  * Add a bunto.github.io/help/ page which elucidates places from which to get help
  * Remove extraneous dash on Plugins doc page which caused a formatting error
  * Change the link to an extension
  * Fix Twitter link on the help page
  * Fix wording in code snippet highlighting section
  * Add a `/` to `paginate_path` in the Pagination documentation
  * Add a link on all the docs pages to "Improve this page".
  * Add bunto-auto-image generator to the list of third-party plugins
  * Replace link to the proposed `picture` element spec
  * Add frontmatter date formatting information
  * Improve consistency and clarity of plugins options note
  * Add permalink warning to pagination docs
  * Fix grammar in Collections docs API stability warning
  * Restructure `excerpt_separator` documentation for clarity
  * Fix accidental line break in collections docs
  * Add information about the `.bunto-metadata` file
  * Document addition of variable parameters to an include
  * Add `bunto-files` to the list of third-party plugins.
  * Define the `install` step in the CI example `.travis.yml`
  * Expand collections documentation.
  * Add the "warning" note label to excluding `vendor` in the CI docs page
  * Upgrade pieces of the Ugrading guide for Bunto 3
  * Showing how to access specific data items
  * Clarify pagination works from within HTML files
  * Add note to `excerpt_separator` documentation that it can be set globally
  * Fix some names on Troubleshooting page
  * Add `remote_file_content` tag plugin to list of third-party plugins
  * Update the Redcarpet version on the Configuration page.
  * Update the link in the welcome post to point to Bunto Talk
  * Update link for navbars with data attributes tutorial
  * Add `bunto-asciinema` to list of third-party plugins
  * Update pagination example to be agnostic to first pagination dir
  * Detailed instructions for rsync deployment method
  * Add Bunto Portfolio Generator to list of plugins
  * Add `site.html_files` to variables docs
  * Add Static Publisher tool to list of deployment methods
  * Fix a few typos.
  * Add `bunto-youtube` to the list of third-party plugins
  * Add Views Router plugin
  * Update install docs (Core dependencies, Windows reqs, etc)
  * Use Bunto Feed for bunto.github.io
  * Add bunto-umlauts to plugins.md
  * Troubleshooting: fix broken link, add other mac-specific info
  * Add a new site for learning purposes
  * Added documentation for Bunto environment variables
  * Fix broken configuration documentation page
  * Add troubleshooting docs for installing on El Capitan
  * Add Lazy Tweet Embedding to the list of third-party plugins
  * Add installation instructions for 2 of 3 options for plugins
  * Add alternative bunto gem installation instructions
  * Fix a few typos and formatting problems.
  * Fix pretty permalink example
  * Note that `_config.yml` is not reloaded during regeneration
  * Apply code block figure syntax to blocks in CONTRIBUTING
  * Add bunto-smartify to the list of third-party plugins
  * Update normalize.css to v3.0.3.
  * Update Font Awesome to v4.4.0.
  * Adds a note about installing the bunto-gist gem to make gist tag work
  * Align hooks documentation with implementation
  * Add Bunto Flickr Plugin to the list of third party plugins
  * Remove link to now-deleted blog post
  * Update the liquid syntax in the pagination docs
  * Add bunto-language-plugin to plugins.md
  * Clarify assets.md
  * Re-correct the liquid syntax in the pagination docs
  * Add `@alfredxing` to the `@bunto/core` team. :tada:
  * Document the `-q` option for the `build` and `serve` commands
  * Fix some minor typos/flow fixes in documentation website content
  * Add `keep_files` to configuration documentation
  * Repeat warning about cleaning of the `destination` directory
  * Add bunto-500px-embed to list of third-party plugins
  * Simplified platform detection in Gemfile example for Windows
  * Add the `bunto-jalali` plugin added to the list of third-party plugins.
  * Add Table of Contents to Troubleshooting page
  * Add `inline_highlight` plugin to list of third-party plugins
  * Add `bunto-mermaid` plugin to list of third-party plugins
  * Add three plugins to directory
  * Add upgrading docs from 2.x to 3.x
  * Add `protect_email` to the plugins index.
  * Add `bunto-deploy` to list of third-party plugins
  * Clarify plugin docs
  * Add Kickster to deployment methods in documentation
  * Add DavidBurela's tutorial for Windows to Windows docs page
  * Change GitHub code block to highlight tag to avoid it overlaps parent div
  * Update FormKeep link to be something more specific to Bunto
  * Remove example Roger Chapman site, as the domain doesn't exist
  * Added configuration options for `draft_posts` to configuration docs
  * Fix checklist in `_assets.md`
  * Add Markdown examples to Pages docs
  * Add bunto-paginate-category to list of third-party plugins
  * Add `bunto-responsive_image` to list of third-party plugins
  * Add `bunto-commonmark` to list of third-party plugins
  * Add documentation for incremental regeneration
  * Add note about removal of relative permalink support in upgrading docs
  * Add Pro Tip to use front matter variable to create clean URLs
  * Fix grammar in the documentation for posts.
  * Add documentation for smartify Liquid filter
  * Fixed broken link to blog on using mathjax with bunto
  * Documentation: correct reference in Precedence section of Configuration docs
  * Add @jmcglone's guide to github-pages doc page
  * Added the Wordpress2Bunto Wordpress plugin
  * Add Contentful Extension to list of third-party plugins
  * Correct Minor spelling error
  * Add bunto-seo-tag, bunto-avatar, and bunto-sitemap to the site
  * Add Google search query to /docs/help/
  * Upgrading, documentation
  * Add 'view source' entry
  * Add bunto-video-embed to list of third-party plugins.
  * Adding Aerobatic to list of deployment options
  * Update documentation: HTMLProofer CLI command
  * Document that subdirectories of `_posts` are no longer categories
  * Update continuous-integration docs with sudo: false information
  * Blog post on refreshed contributing file and new affinity teams
  * Fixes typo on collections
  * Documentation: future option also works for collections
  * Additional package needed for Fedora 23 Workspace
  * Fix typo on Chocolatey name in Windows documentation
  * Use the correct URL
  * Add bunto-paspagon plugin
  * Bold-italicize note in assets documentation about needing yaml front matter
  * Highlight the `script/` calls in the Contributing documentation
  * Add Hawkins to the list of third-party plugins
  * Fix a typo in pagination doc
  * Switch second GitHub Pages link to HTTPS
  * Explain data file format requirements more clearly in documentation
  * Add bunto-i18n_tags to list of third-party plugins
  * Remove Leonard Lamprecht's website from Sites page
  * Updates documentation for collections to include `date` property
  * Added an explicit rerun note to configuration.md, defaults section
  * Update Rack-Bunto Heroku deployment blog post url
  * Added missing single quote on rsync client side command
  * Organize Form Platforms-as-a-Service into unified list & add FormSpree.io
  * Fixed typo on Configuration page
  * Update FormKeep URL on the Resources doc
  * Add bunto-toc plugin
  * Docs: Quickstart - added documentation about the `--force` option
  * Fix broken links to the Code of Conduct
  * Upgrade notes: mention trailing slash in permalink
  * Add hooks to the plugin categories toc
  * Fix typo in upgrading docs
  * Add note about upgrading documentation on bunto.github.io/help/
  * Update Rake link
  * Update & prune the short list of example sites
  * Added amp-bunto plugin to plugins docs
  * A few grammar fixes
  * Correct a couple mistakes in structure.md
  * site: use liquid & reduce some whitespace noise

### Meta

  * Update the Code of Conduct to the latest version

----

## 2.0.0.pre / 

  * Second pre-release!

### Site Enhancements

  * Bunto 2 requires newer version of Ruby.

----

## 1.0.0 / 2016-02-14

  * First release!

----

## 0.0.1 / 2015-05-30

  * Birthday!
  * First pre-release!
