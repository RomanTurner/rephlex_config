require 'zeitwerk'
require 'dotenv/load'
require 'filewatcher'

require_relative 'db'
require_relative 'models'
Dotenv.load
loader = Zeitwerk::Loader.new
loader.push_dir("backend")
loader.ignore("**/routes.rb")

if ENV['RACK_ENV'] = "development"
    loader.enable_reloading
    my_filewatcher = Filewatcher.new('backend/')
    Thread.new(my_filewatcher) {|fw| fw.watch {|filename| loader.reload } }
end

loader.setup
