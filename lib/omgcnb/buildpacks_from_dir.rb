# frozen_string_literal: true

module Omgcnb
  class BuildpacksFromDir
    def initialize(dir: , exclude: [], allow_test: false)
      @dir = dir
      @exclude = exclude
      if !allow_test
        exclude << dir.join("test")
        exclude << dir.join("spec")
      end
    end

    def buildpacks
      @buildpacks ||= ScanBuildpackToml.new(dir: @dir, exclude: @exclude).call.files.map do |file|
        changelog = file.parent.join("CHANGELOG.md")

        raise "Expected #{changelog} to exist but it does not" unless changelog.exist?
        BitOfBuildpack.new(
          toml_contents: file.read,
          changelog_contents: changelog.read
        )
      end
    end
  end
end
