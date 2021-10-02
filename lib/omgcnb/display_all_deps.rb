# frozen_string_literal: true

module Omgcnb
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
