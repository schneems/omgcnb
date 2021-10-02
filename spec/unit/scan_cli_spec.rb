# frozen_string_literal: true

require_relative "../spec_helper"

module Omgcnb
  RSpec.describe ScanCLI do
    it "does not error" do
      dir = node_buildpack_dir

      io = StringIO.new
      ScanCLI.new(dir: dir, exclude: [], io: io).call

      expect(io.string).to include("Needs release")
    end
  end
end
