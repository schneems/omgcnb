# frozen_string_literal: true

require_relative "../spec_helper"

module Omgcnb

  RSpec.describe  BuildpacksFromDir do
    it "" do
      skip
      buildpacks =  BuildpacksFromDir.new(
        dir: "/Users/rschneeman/Documents/projects/work/buildpacks/buildpacks-nodejs",
        exclude: ["/Users/rschneeman/Documents/projects/work/buildpacks/buildpacks-nodejs/test"]
      ).buildpacks

      needs_release = ResolveDependencies.new(buildpacks).solution
      puts "## Needs Release\n\n"
      needs_release.each do |b|
        DisplayAllDeps.new(b).call
      end
    end
  end
end
