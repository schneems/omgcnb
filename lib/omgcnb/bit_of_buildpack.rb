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

    def depends_on(show_optional: false)
      @depends_on = toml&.[](:order)
          &.map { |group_array| group_array[:group] }
          &.flatten
          &.map {|group|
            if show_optional || !group[:optional]
              group[:id]
            else
              nil
            end
          }&.compact || []
    end
  end
end
