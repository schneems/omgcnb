# frozen_string_literal: true

require_relative "../spec_helper"

module Omgcnb
  RSpec.describe DisplayAllDeps do
    it "does not error" do
      io = StringIO.new
      buildpack = BitOfBuildpack.new(toml_contents: java_function_invoker_toml, changelog_contents: mock_changelog(needs_release: true))

      DisplayAllDeps.new(buildpack, io: io).call

      expect(io.string).to include("- heroku/jvm-function-invoker")
      expect(io.string).to include("  - (no deps)")
    end
  end
end
