# frozen_string_literal: true


module Omgcnb
  class ScanBuildpackToml
    def initialize(dir: , exclude: [])
      @dir = Pathname(dir)
      @exclude = exclude.map {|p| Pathname(p) }

      @buildpack_toml_files = []
    end

    def call
      scan_dir(@dir)
      self
    end

    def files
      @buildpack_toml_files
    end

    private def scan_dir(dir)
      return if @exclude.include?(dir)

      dir.join("buildpack.toml").tap do |file|
        @buildpack_toml_files << file if file.exist?
      end

      dir.children.each do |d|
        scan_dir(d) if d.directory?
      end
    end
  end
end
