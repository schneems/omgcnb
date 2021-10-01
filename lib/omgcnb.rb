# frozen_string_literal: true

require 'pathname'
require 'kramdown'
require 'nokogiri'
require 'tomlrb'
require_relative "omgcnb/version"

module Omgcnb
  class Error < StandardError; end

  class BitOfBuildpack
    attr_reader :name
    def initialize(name: , dir:)
      @name = name
      @dir = dir
      @changelog = dir.join("CHANGELOG.md")
      @toml_file = dir.join("buildpack.toml")
      @unreleased_markdown = UnreleasedMarkdown.new(@changelog.read)
    end

    def needs_release?
      @unreleased_markdown.needs_release?
    end

    def toml
      @toml ||= Tomlrb.parse(@toml_file.read, symbolize_keys: true)
    end

    def depends_on
      return @depends_on if defined?(@depends_on)
      @depends_on = toml&.[](:order)
          &.map { |group_array| group_array[:group] }
          &.flatten
          &.map {|group| group[:id] } || []
    end
  end

  class ResolveDependencies
    def initialize(buildpacks)
      @order = []

      @unsolved = buildpacks.select(&:needs_release?)
      @solved = buildpacks - @unsolved
      @buildpacks = buildpacks
    end

    def call
      while @unsolved.any?
        next_buildpacks = @unsolved.select { |buildpack|
          (buildpack.depends_on - @solved.map(&:name)).empty?
        }
        @order.concat(next_buildpacks)
        @solved.concat(next_buildpacks)
        @unsolved = @unsolved - next_buildpacks
      end
    end

    def solution
      call
      @order
    end
  end

  # buildpacks = [
  #   BitOfBuildpack.new(name: "heroku/jvm", dir: Pathname("buildpacks").join("jvm")),
  #   BitOfBuildpack.new(name: "heroku/jvm-function-invoker", dir: Pathname("buildpacks").join("jvm-function-invoker")),
  #   BitOfBuildpack.new(name: "heroku/maven", dir: Pathname("buildpacks").join("maven")),
  #   BitOfBuildpack.new(name: "heroku/java", dir: Pathname("meta-buildpacks").join("java")),
  #   BitOfBuildpack.new(name: "heroku/java-function", dir: Pathname("meta-buildpacks").join("java-function")),
  # ]

  # ResolveDependencies.new(buildpacks).solution.each_with_index do |buildpack, i|
  #   puts <<~EOM
  #     #{i.zero? ? "Release" : "And then release"} Buildpack: '#{buildpack.name}'
  #     Depends on: #{buildpack.depends_on.inspect}

  #   EOM
  # end

end
require_relative 'omgcnb/unreleased_markdown'
