# frozen_string_literal: true

require_relative "../spec_helper"

module Omgcnb
  RSpec.describe BuildpacksFromDir do
    it "does not error" do
      dir = node_buildpack_dir
      buildpacks = BuildpacksFromDir.new(dir: dir).buildpacks
      expect(buildpacks.count).to eq(7)
    end
  end
end
