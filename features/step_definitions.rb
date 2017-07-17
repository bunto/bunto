Before do
  FileUtils.rm_rf(Paths.test_dir) if Paths.test_dir.exist?
  FileUtils.mkdir_p(Paths.test_dir) unless Paths.test_dir.directory?
  Dir.chdir(Paths.test_dir)
end

#

After do
  FileUtils.rm_rf(Paths.test_dir) if Paths.test_dir.exist?
  Paths.output_file.delete if Paths.output_file.exist?
  Paths.status_file.delete if Paths.status_file.exist?
  Dir.chdir(Paths.test_dir.parent)
end

#

Given(%r!^I have a blank site in "(.*)"$!) do |path|
  unless File.exist?(path)
    then FileUtils.mkdir_p(path)
  end
end

#

Given(%r!^I do not have a "(.*)" directory$!) do |path|
  Paths.test_dir.join(path).directory?
end

#

Given(%r!^I have an? "(.*)" page(?: with (.*) "(.*)")? that contains "(.*)"$!) do |file, key, value, text|
  File.write(file, Bunto::Utils.strip_heredoc(<<-DATA))
    ---
    #{key || "layout"}: #{value || "nil"}
    ---

    #{text}
  DATA
end

#

Given(%r!^I have an? "(.*)" file that contains "(.*)"$!) do |file, text|
  File.write(file, text)
end

#

Given(%r!^I have an? (.*) (layout|theme) that contains "(.*)"$!) do |name, type, text|
  folder = type == "layout" ? "_layouts" : "_theme"

  destination_file = Pathname.new(File.join(folder, "#{name}.html"))
  FileUtils.mkdir_p(destination_file.parent) unless destination_file.parent.directory?
  File.write(destination_file, text)
end

#

Given(%r!^I have an? "(.*)" file with content:$!) do |file, text|
  File.write(file, text)
end

#

Given(%r!^I have an? (.*) directory$!) do |dir|
  unless File.directory?(dir)
    then FileUtils.mkdir_p(dir)
  end
end

#

Given(%r!^I have the following (draft|page|post)s?(?: (in|under) "([^"]+)")?:$!) do |status, direction, folder, table|
  table.hashes.each do |input_hash|
    title = slug(input_hash["title"])
    ext = input_hash["type"] || "markdown"
    filename = "#{title}.#{ext}" if %w(draft page).include?(status)
    before, after = location(folder, direction)
    dest_folder = "_drafts" if status == "draft"
    dest_folder = "_posts"  if status == "post"
    dest_folder = "" if status == "page"

    if status == "post"
      parsed_date = Time.xmlschema(input_hash["date"]) rescue Time.parse(input_hash["date"])
      filename = "#{parsed_date.strftime("%Y-%m-%d")}-#{title}.#{ext}"
    end

    path = File.join(before, dest_folder, after, filename)
    File.write(path, file_content_from_hash(input_hash))
  end
end

#

Given(%r!^I have a configuration file with "(.*)" set to "(.*)"$!) do |key, value|
  config = \
    if source_dir.join("_config.yml").exist?
      SafeYAML.load_file(source_dir.join("_config.yml"))
    else
      {}
    end
  config[key] = YAML.load(value)
  File.write("_config.yml", YAML.dump(config))
end

#

Given(%r!^I have a configuration file with:$!) do |table|
  table.hashes.each do |row|
    step %(I have a configuration file with "#{row["key"]}" set to "#{row["value"]}")
  end
end

#

Given(%r!^I have a configuration file with "([^\"]*)" set to:$!) do |key, table|
  File.open("_config.yml", "w") do |f|
    f.write("#{key}:\n")
    table.hashes.each do |row|
      f.write("- #{row["value"]}\n")
    end
  end
end

#

Given(%r!^I have fixture collections$!) do
  FileUtils.cp_r Paths.source_dir.join("test", "source", "_methods"), source_dir
  FileUtils.cp_r Paths.source_dir.join("test", "source", "_thanksgiving"), source_dir
end

#

Given(%r!^I wait (\d+) second(s?)$!) do |time, _|
  sleep(time.to_f)
end

#

When(%r!^I run bunto(.*)$!) do |args|
  run_bunto(args)
  if args.include?("--verbose") || ENV["DEBUG"]
    $stderr.puts "\n#{bunto_run_output}\n"
  end
end

#

When(%r!^I run bundle(.*)$!) do |args|
  run_bundle(args)
  if args.include?("--verbose") || ENV["DEBUG"]
    $stderr.puts "\n#{bunto_run_output}\n"
  end
end

#

When(%r!^I run gem(.*)$!) do |args|
  run_rubygem(args)
  if args.include?("--verbose") || ENV["DEBUG"]
    $stderr.puts "\n#{bunto_run_output}\n"
  end
end

#

When(%r!^I run git add .$!) do
  run_in_shell("git", "add", ".", "--verbose")
end

#

When(%r!^I decide to build the theme gem$!) do
  Dir.chdir(Paths.theme_gem_dir)
  gemspec = "my-cool-theme.gemspec"
  File.write(gemspec, File.read(gemspec).sub("TODO: ", ""))
  File.new("_includes/blank.html", "w")
  File.new("_sass/blank.scss", "w")
  File.new("assets/blank.scss", "w")
end

#

When(%r!^I change "(.*)" to contain "(.*)"$!) do |file, text|
  File.open(file, "a") do |f|
    f.write(text)
  end
end

#

When(%r!^I delete the file "(.*)"$!) do |file|
  File.delete(file)
end

#

Then(%r!^the (.*) directory should +(not )?exist$!) do |dir, negative|
  if negative.nil?
    expect(Pathname.new(dir)).to exist
  else
    expect(Pathname.new(dir)).to_not exist
  end
end

#

Then(%r!^I should (not )?see "(.*)" in "(.*)"$!) do |negative, text, file|
  step %(the "#{file}" file should exist)
  regexp = Regexp.new(text, Regexp::MULTILINE)
  if negative.nil? || negative.empty?
    expect(file_contents(file)).to match regexp
  else
    expect(file_contents(file)).not_to match regexp
  end
end

#

Then(%r!^I should (not )?see "(.*)" in "(.*)" if on Windows$!) do |negative, text, file|
  step %(the "#{file}" file should exist)
  regexp = Regexp.new(text, Regexp::MULTILINE)
  if negative.nil? || negative.empty?
    if Bunto::Utils::Platforms.really_windows?
      expect(file_contents(file)).to match regexp
    else
      expect(file_contents(file)).not_to match regexp
    end
  end
end

#

Then(%r!^I should (not )?see "(.*)" in "(.*)" unless Windows$!) do |negative, text, file|
  step %(the "#{file}" file should exist)
  regexp = Regexp.new(text, Regexp::MULTILINE)
  if negative.nil? || negative.empty?
    if Bunto::Utils::Platforms.really_windows?
      expect(file_contents(file)).not_to match regexp
    else
      expect(file_contents(file)).to match regexp
    end
  end
end

#

Then(%r!^I should see exactly "(.*)" in "(.*)"$!) do |text, file|
  step %(the "#{file}" file should exist)
  expect(file_contents(file).strip).to eq text
end

#

Then(%r!^I should see escaped "(.*)" in "(.*)"$!) do |text, file|
  step %(I should see "#{Regexp.escape(text)}" in "#{file}")
end

#

Then(%r!^the "(.*)" file should +(not )?exist$!) do |file, negative|
  if negative.nil?
    expect(Pathname.new(file)).to exist
  else
    expect(Pathname.new(file)).to_not exist
  end
end

#

Then(%r!^I should see today's time in "(.*)"$!) do |file|
  step %(I should see "#{seconds_agnostic_time(Time.now)}" in "#{file}")
end

#

Then(%r!^I should see today's date in "(.*)"$!) do |file|
  step %(I should see "#{Date.today}" in "#{file}")
end

#

Then(%r!^I should (not )?see "(.*)" in the build output$!) do |negative, text|
  if negative.nil? || negative.empty?
    expect(bunto_run_output).to match Regexp.new(text)
  else
    expect(bunto_run_output).not_to match Regexp.new(text)
  end
end

#

Then(%r!^I should get an updated git index$!) do
  index = %w(
    .gitignore
    Gemfile
    LICENSE.txt
    README.md
    _includes/blank.html
    _layouts/default.html
    _layouts/page.html
    _layouts/post.html
    _sass/blank.scss
    assets/blank.scss
    my-cool-theme.gemspec
  )
  index.each do |file|
    expect(bunto_run_output).to match file
  end
end

#

Then(%r!^I should get a zero exit(?:\-| )status$!) do
  step %(I should see "EXIT STATUS: 0" in the build output)
end

#

Then(%r!^I should get a non-zero exit(?:\-| )status$!) do
  step %(I should not see "EXIT STATUS: 0" in the build output)
end
