# frozen_string_literal: true

require_relative "../spec_helper"

module OmgCnb
  RSpec.describe Omgcnb do
    it "has a version number" do
        expect(Omgcnb::VERSION).not_to be nil
    end
  end
end
