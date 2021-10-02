# frozen_string_literal: true

require 'fileutils'
require 'tmpdir'
require "omgcnb"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def root_dir
  Pathname(__dir__).join("..")
end

def node_buildpack_dir
  target_dir = root_dir.join('tmp/nodejs')
  if !target_dir.exist?
    run!("git clone https://github.com/heroku/buildpacks-nodejs #{target_dir} && cd #{target_dir} && git checkout 1234f3a62fb47e9c025d46f43bedf0d75e461aac")
  end
  target_dir
end

def run!(cmd, allow_fail: false)
  out = `#{cmd} 2&>1`
  raise "Command #{cmd} failed: #{out}" if !$?.success? && !allow_fail
  out
end

def mock_toml(name: )
  <<~EOM
  [buildpack]
  id = "#{name}"
  EOM
end

def mock_changelog(needs_release: false)
  changelog = String.new()
  changelog << "## unreleased\n"
  changelog << "- lol" if needs_release

  changelog
end

def java_function_toml
  <<~EOM
    api = "0.4"

    [buildpack]
    id = "heroku/java-function"
    version = "0.3.23"
    name = "Java Function"
    homepage = "https://github.com/heroku/buildpacks-jvm"
    keywords = ["java", "function"]

    [[licenses]]
    type = "MIT"

    [[order]]

    [[order.group]]
    id = "heroku/jvm"
    version = "0.1.8"

    [[order.group]]
    id = "heroku/maven"
    version = "0.2.5"

    [[order.group]]
    id = "heroku/jvm-function-invoker"
    version = "0.5.4"

    [metadata]

    [metadata.release]

    [metadata.release.docker]
    repository = "public.ecr.aws/heroku-buildpacks/heroku-java-function-buildpack"
  EOM
end

def java_function_invoker_toml
  <<~EOM
    api = "0.5"

    [buildpack]
    id = "heroku/jvm-function-invoker"
    version = "0.5.5"
    name = "JVM Function Invoker"
    clear-env = true
    homepage = "https://github.com/heroku/buildpacks-jvm"
    keywords = ["java", "function"]

    [[licenses]]
    type = "MIT"

    [[stacks]]
    id = "heroku-18"

    [[stacks]]
    id = "heroku-20"

    [[stacks]]
    id = "io.buildpacks.stacks.bionic"

    [metadata]

    [metadata.runtime]
    url = "https://repo1.maven.org/maven2/com/salesforce/functions/sf-fx-runtime-java-runtime/1.0.3/sf-fx-runtime-java-runtime-1.0.3-jar-with-dependencies.jar"
    sha256 = "1db6d78bdbb7aff7ebe011565190ca9dd4d3e68730e206628230d480d057fe1e"

    [metadata.release]

    [metadata.release.docker]
    repository = "public.ecr.aws/heroku-buildpacks/heroku-jvm-function-invoker-buildpack"
  EOM
end
