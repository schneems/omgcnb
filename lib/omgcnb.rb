# frozen_string_literal: true

require 'pathname'
require 'kramdown'
require 'nokogiri'
require 'tomlrb'
require_relative "omgcnb/version"

module Omgcnb
  class Error < StandardError; end

  class BuildpacksFromDir
    def initialize(dir: , exclude: [])
      @dir = dir
      @exclude = exclude
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

  class DisplayAllDeps
    attr_reader :io, :buildpack

    def initialize(buildpack, io: STDOUT)
      @buildpack = buildpack
      @io = io
    end

    def call
      io.puts "- #{buildpack.name}"
      if buildpack.depends_on.any?
        io.puts "#{buildpack.depends_on(show_optional: true).map {|s| "  - #{s}" }.join("\n")}"
      else
        io.puts "  - (no deps)"
      end
    end
  end
end

require_relative 'omgcnb/resolve_dependencies'
require_relative 'omgcnb/unreleased_markdown'
require_relative 'omgcnb/bit_of_buildpack'
require_relative 'omgcnb/scan_buildpack_toml'
