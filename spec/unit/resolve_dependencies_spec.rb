# frozen_string_literal: true

require_relative "../spec_helper"

module Omgcnb
  RSpec.describe ResolveDependencies do
    it "knows if it cannot resolve" do
      buildpacks = []
      buildpacks << BitOfBuildpack.new(toml_contents: java_function_invoker_toml, changelog_contents: mock_changelog(needs_release: true))
      buildpacks << BitOfBuildpack.new(toml_contents: java_function_toml, changelog_contents: mock_changelog(needs_release: true))

      expect {
        ResolveDependencies.new(buildpacks).solution
      }.to raise_error(/Cannot satisfy/)
    end

    it "resolves buildpacks with no dependencies" do
      buildpacks = []
      buildpacks << BitOfBuildpack.new(toml_contents: java_function_invoker_toml, changelog_contents: mock_changelog(needs_release: true))

      solution = ResolveDependencies.new(buildpacks).solution
      expect(solution).to eq([buildpacks.first])
    end

    it "resolves buildpacks with ALL the dependencies" do
      buildpacks = []
      buildpacks << BitOfBuildpack.new(toml_contents: java_function_invoker_toml, changelog_contents: mock_changelog(needs_release: true))
      buildpacks << BitOfBuildpack.new(toml_contents: java_function_toml, changelog_contents: mock_changelog(needs_release: true))
      buildpacks << BitOfBuildpack.new(toml_contents: mock_toml(name: "heroku/jvm"), changelog_contents: mock_changelog(needs_release: false))
      buildpacks << BitOfBuildpack.new(toml_contents: mock_toml(name: "heroku/maven"), changelog_contents: mock_changelog(needs_release: false))

      solution = ResolveDependencies.new(buildpacks).solution
      expect(solution[0].name).to eq("heroku/jvm-function-invoker")
      expect(solution[1].name).to eq("heroku/java-function")
    end
  end
end
