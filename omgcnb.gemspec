# frozen_string_literal: true

require_relative "lib/omgcnb/version"

Gem::Specification.new do |spec|
  spec.name          = "omgcnb"
  spec.version       = Omgcnb::VERSION
  spec.authors       = ["schneems"]
  spec.email         = ["richard.scheeman+foo@gmail.com"]

  spec.summary       = "OMG CNB"
  spec.description   = "OMG CNB"
  spec.homepage      = "https://example.com"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"


  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://example.com"
  spec.metadata["changelog_uri"] = "https://example.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "kramdown", ">= 1.0"
  spec.add_dependency "tomlrb", ">= 1.0"
  spec.add_dependency "nokogiri", ">= 1.0"
  spec.add_development_dependency "dead_end", ">= 0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
