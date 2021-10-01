# frozen_string_literal: true

module Omgcnb
  class ResolveDependencies
    def initialize(buildpacks)
      @order = []
      @unsolved = buildpacks.select(&:needs_release?)
      @solved = buildpacks - @unsolved
      @buildpacks = buildpacks

      given_buildpacks = buildpacks.flat_map {|b| b.name }
      @buildpacks.each do |buildpack|
        depends_diff = buildpack.depends_on - given_buildpacks
        raise "Cannot satisfy '#{buildpack.name}' missing: #{depends_diff}" unless depends_diff.empty?
      end
    end

    def call
      while @unsolved.any?
        found = @unsolved.select { |buildpack|
          (buildpack.depends_on - @solved.map(&:name)).empty?
        }
        @order.concat(found)
        @solved.concat(found)
        @unsolved -=found
      end
    end

    def solution
      call
      @order
    end
  end
end
