# frozen_string_literal: true

require_relative "../spec_helper"

module Omgcnb
  RSpec.describe ScanBuildpackToml do
    it "finds a buildpack when given one" do
      Dir.mktmpdir do |dir|
        Pathname(dir)
          .join("buildpack.toml")
          .write("")
        scan = ScanBuildpackToml.new(dir: dir).call

        expect(scan.files.count).to eq(1)
      end
    end

    it "searches nested directories" do
      Dir.mktmpdir do |dir|
        Pathname(dir)
          .join("my")
          .join("little")
          .join("pony")
          .tap(&:mkpath)
          .join("buildpack.toml")
          .write("")

        scan = ScanBuildpackToml.new(dir: dir).call
        expect(scan.files.count).to eq(1)

        # It allows exclusion of directories
        scan = ScanBuildpackToml.new(
          dir: dir,
          exclude: [Pathname(dir).join("my")]
        ).call
        expect(scan.files.count).to eq(0)
      end
    end

    it "finds nothing when given nothing" do
      Dir.mktmpdir do |dir|
        scan = ScanBuildpackToml.new(dir: dir).call

        expect(scan.files.count).to eq(0)
      end
    end
  end
end
