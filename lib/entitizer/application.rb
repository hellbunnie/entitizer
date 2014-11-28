module Entitizer
  class Application
    require 'htmlentities'

    def initialize(argv)
      @params, @dir = parse_options(argv)
    end

    def run
      if @dir.nil? || @dir.empty?
        puts "Usage: entitizer [-d] directory"
      else
        Dir.entries(@dir).each do |filename|
          if File.file?(File.join(@dir,filename))

            infile = String.new
            File.open(File.join(@dir,filename)) do |f|
              infile = File.read(f).to_s
            end

            Dir.mkdir(File.join(@dir, "out")) unless File.exists?(File.join(@dir, "out"))

            if @params[:action].eql?(:decode)
              out = HTMLEntities.new.decode(infile)
            else
              out = HTMLEntities.new.encode(infile)
            end

            outfile = File.open(File.join(@dir, "out", filename), "w")
            File.write(outfile, out)
            outfile.close
          end
        end
      end
    end

    def parse_options(argv)
      params = {}
      parser = OptionParser.new

      params[:action] = :encode
      parser.on("-d") { params[:action] = :decode }

      dir = parser.parse(argv).first

      [params, dir]
    end
  end
end
