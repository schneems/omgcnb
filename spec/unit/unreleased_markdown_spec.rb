# frozen_string_literal: true

require_relative "../spec_helper"


module Omgcnb
  RSpec.describe "Unreleased markdown" do
    it "works with empty changelog" do
        markdown = UnreleasedMarkdown.new(<<~EOM)
        EOM

        expect(markdown.needs_release?).to be_falsey
    end

    it "works with upcase changelog" do
        markdown = UnreleasedMarkdown.new(<<~EOM)
        ## Unreleased

        * lol
        EOM

        expect(markdown.needs_release?).to be_truthy
    end

    it "knows when there's an entry in unreleased" do
        markdown = UnreleasedMarkdown.new(<<~EOM)
            # Pretend changelog

            ## unreleased

            * lol

            ## v0.2.3

            * omg
        EOM

        expect(markdown.needs_release?).to be_truthy
    end

    it "knows when there's not an entry in unreleased" do
        markdown = UnreleasedMarkdown.new(<<~EOM)
            # Pretend changelog

            ## unreleased

            ## v0.2.3

            * omg
        EOM

        expect(markdown.needs_release?).to be_falsey
    end

    it "can extract changed list" do
        markdown = UnreleasedMarkdown.new(<<~EOM)
            ## unreleased

            * lol
        EOM

        expect(markdown.changed_list.join("\n")).to eq("- lol")

        markdown = UnreleasedMarkdown.new(<<~EOM)
            ## unreleased

            * lol
            * hahaha
        EOM

        expect(markdown.changed_list.join("\n")).to eq("- lol\n- hahaha")
    end
  end
end
