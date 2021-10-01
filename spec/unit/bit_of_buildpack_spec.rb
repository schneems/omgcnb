# frozen_string_literal: true

require_relative "../spec_helper"

module Omgcnb
  RSpec.describe BitOfBuildpack do
    it "parses dependencies" do
      buildpack = BitOfBuildpack.new(toml_contents: java_function_toml, changelog_contents: "")
      expect(buildpack.depends_on).to eq(["heroku/jvm", "heroku/maven", "heroku/jvm-function-invoker"])
      expect(buildpack.needs_release?).to be_falsey
      expect(buildpack.name).to eq("heroku/java-function")

      buildpack = BitOfBuildpack.new(toml_contents: java_function_invoker_toml, changelog_contents: "")
      expect(buildpack.depends_on).to eq([])
      expect(buildpack.name).to eq("heroku/jvm-function-invoker")
    end

    it "ignores optional deps" do
      buildpack = BitOfBuildpack.new(
        changelog_contents: mock_changelog,
        toml_contents: <<~EOM
          [buildpack]
          id = "foo"

          [[order]]

          [[order.group]]
          id = "heroku/procfile"
          version = "0.6.2"
          optional = true
        EOM
      )

      expect(buildpack.depends_on(show_optional: false)).to eq([])
      expect(buildpack.depends_on(show_optional: true)).to eq(["heroku/procfile"])
    end
  end
end
