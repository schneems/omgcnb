# frozen_string_literal: true

module Omgcnb
  class UnreleasedMarkdown
    def initialize(markdown_text)
      @markdown_text = markdown_text
    end

    def needs_release?
      unreleased_ul
    end

    def html
      @html ||= Kramdown::Document.new(@markdown_text).to_html
    end

    def nokogiri
      @nokogiri ||= Nokogiri::HTML(html)
    end

    def changed_list
      return [] unless unreleased_ul
      unreleased_ul.xpath("//li").map {|li| "- #{li.content}" }
    end

    def unreleased_ul
      return @unreleased_ul if defined?(@unreleased_ul)
      @unreleased_ul = search_ul
    end

    def search_ul
      # Find h2 header with "unreleased"
      # search to see if the next element is an "h2" (no unreleased changes)
      # or it is "ul" (has unreleased changes)
      node = unreleased_h2&.next_sibling
      while node
        node = node.next_sibling
        case node.name
        when "h2"
          return nil
        when "ul"
          return node
        end
      end
    end

    def unreleased_h2
      nokogiri.xpath("//h2[@id='unreleased']").first
    end
  end
end
