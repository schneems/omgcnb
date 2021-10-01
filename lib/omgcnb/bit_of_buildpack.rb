# frozen_string_literal: true

module Omgcnb
  class BitOfBuildpack
    attr_reader :name
    def initialize(toml_contents: , changelog_contents: )
      @toml = Tomlrb.parse(toml_contents, symbolize_keys: true)
      @name = toml.fetch(:buildpack).fetch(:id)

      @unreleased_markdown = UnreleasedMarkdown.new(changelog_contents)
    end

    def needs_release?
      @unreleased_markdown.needs_release?
    end

    def toml
      @toml
    end

    def depends_on
      return @depends_on if defined?(@depends_on)
      @depends_on = toml&.[](:order)
          &.map { |group_array| group_array[:group] }
          &.flatten
          &.map {|group| group[:id] } || []
    end
  end
end
