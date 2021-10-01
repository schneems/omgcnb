# frozen_string_literal: true

require 'pathname'
require 'kramdown'
require 'nokogiri'
require 'tomlrb'
require_relative "omgcnb/version"

module Omgcnb
  class Error < StandardError; end

end

require_relative 'omgcnb/resolve_dependencies'
require_relative 'omgcnb/unreleased_markdown'
require_relative 'omgcnb/bit_of_buildpack'
require_relative 'omgcnb/scan_buildpack_toml'
