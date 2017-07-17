#############################################################################
#
# Site tasks - https://buntowaf.tk
#
#############################################################################

namespace :site do
  task :generated_pages => [:history, :version_file, :conduct, :contributing]

  desc "Generate and view the site locally"
  task :preview => :generated_pages do
    require "launchy"
    require "bunto"

    browser_launched = false
    Bunto::Hooks.register :site, :post_write do |_site|
      next if browser_launched
      browser_launched = true
      Bunto.logger.info "Opening in browser..."
      Launchy.open("http://localhost:4000")
    end

    # Generate the site in server mode.
    puts "Running Bunto..."
    options = {
      "source"      => File.expand_path(docs_folder),
      "destination" => File.expand_path("#{docs_folder}/_site"),
      "watch"       => true,
      "serving"     => true,
    }
    Bunto::Commands::Build.process(options)
    Bunto::Commands::Serve.process(options)
  end

  desc "Generate the site"
  task :generate => :generated_pages do
    require "bunto"
    Bunto::Commands::Build.process({
      "profile"     => true,
      "source"      => File.expand_path(docs_folder),
      "destination" => File.expand_path("#{docs_folder}/_site"),
    })
  end
  task :build => :generate

  desc "Update normalize.css library to the latest version and minify"
  task :update_normalize_css do
    Dir.chdir("#{docs_folder}/_sass") do
      sh 'curl "https://necolas.github.io/normalize.css/latest/normalize.css" -o "normalize.scss"'
      sh 'sass "normalize.scss":"_normalize.scss" --style compressed'
      rm ["normalize.scss", Dir.glob("*.map")].flatten
    end
  end

  desc "Generate generated pages and publish to GitHub Pages"
  task :publish => :generated_pages do
    puts "GitHub Pages now compiles our docs site on every push to the `master` branch. Cool, huh?"
    exit 1
  end

  desc "Create a nicely formatted history page for the bunto site based on the repo history."
  task :history do
    siteify_file("History.markdown", { "title" => "History" })
  end

  desc "Copy the Code of Conduct"
  task :conduct do
    front_matter = {
      "redirect_from" => "/conduct/index.html",
      "editable"      => false,
    }
    siteify_file("CONDUCT.markdown", front_matter)
  end

  desc "Copy the contributing file"
  task :contributing do
    siteify_file(".github/CONTRIBUTING.markdown", "title" => "Contributing")
  end

  desc "Write the site latest_version.txt file"
  task :version_file do
    File.open("#{docs_folder}/latest_version.txt", "wb") { |f| f.puts(version) } unless version =~ %r!(beta|rc|alpha)!i
  end

  namespace :releases do
    desc "Create new release post"
    task :new, :version do |_t, args|
      raise "Specify a version: rake site:releases:new['1.2.3']" unless args.version
      today = Time.new.strftime("%Y-%m-%d")
      release = args.version.to_s
      filename = "#{docs_folder}/_posts/#{today}-bunto-#{release.split(".").join("-")}-released.markdown"

      File.open(filename, "wb") do |post|
        post.puts("---")
        post.puts("title: 'Bunto #{release} Released'")
        post.puts("date: #{Time.new.strftime("%Y-%m-%d %H:%M:%S %z")}")
        post.puts("author: ")
        post.puts("version: #{release}")
        post.puts("categories: [release]")
        post.puts("---")
        post.puts
        post.puts
      end

      puts "Created #{filename}"
    end
  end
end
