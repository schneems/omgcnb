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
  end
end
