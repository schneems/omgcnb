module Omgcnb
  class ScanCLI
    attr_reader :directory, :exclude, :io

    def initialize(dir: , exclude: [], allow_test: false, io: STDOUT)
      @io = io
      @exclude = exclude
      @allow_test = allow_test
      @directory = Pathname(dir).expand_path
    end

    def buildpacks
      @buildpacks ||=  Omgcnb::BuildpacksFromDir.new(
        dir: @directory,
        exclude: @exclude,
        allow_test: @allow_test,
      ).buildpacks
    end

    def needs_release
      @needs_release ||= Omgcnb::ResolveDependencies.new(buildpacks).solution
    end

    def title(title)
      io.puts
      io.puts "## #{title}"
      io.puts
    end

    def call
      title("Needs release")
      needs_release.each_with_index do |buildpack, i|
        io.puts "#{i.next}) #{buildpack.name}"
        buildpack.changed_list.each do |line|
          io.puts "  #{line}"
        end
      end
      title("All Buildpacks")
      buildpacks.each do |buildpack|
        Omgcnb::DisplayAllDeps.new(buildpack, io: io).call
      end
    end
  end
end
