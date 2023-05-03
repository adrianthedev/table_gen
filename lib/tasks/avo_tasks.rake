# desc 'Explaining what the task does'
# task :table_gen do
#   # Task goes here
# end

desc "Installs TableGen assets and bundles them for when you want to use the GitHub repo in your app"
task "table_gen:build-assets" do
  spec = get_gem_spec "table_gen"
  # Uncomment to enable only when the source is github.com
  enabled = true

  if enabled
    puts "Starting table_gen:build-assets"
    path = spec.full_gem_path

    Dir.chdir(path) do
      system "yarn"
      system "yarn prod:build"
    end

    puts "Done"
  else
    puts "Not starting table_gen:build-assets"
  end
end

# From
# https://stackoverflow.com/questions/9322078/programmatically-determine-gems-path-using-bundler
def get_gem_spec(name)
  spec = Bundler.load.specs.find { |s| s.name == name }
  raise GemNotFound, "Could not find gem '#{name}' in the current bundle." unless spec
  if spec.name == "bundler"
    return File.expand_path("../../../", __FILE__)
  end

  spec
end
