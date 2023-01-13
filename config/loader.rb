require 'zeitwerk'
require 'dotenv/load'
require 'filewatcher'

require 'phlex'
require 'vite_ruby'
require_relative 'vite_rephlex'
# To configure vite_tag helpers with phlex components.
# I want to make them availible to all the components in the library.
Phlex::HTML.include(ViteRephlex)

require_relative 'db'
require_relative 'models'

Dotenv.load
loader = Zeitwerk::Loader.new
loader.push_dir("allocs")
loader.ignore("**/routes.rb")

if ENV['RACK_ENV'] = "development"
    loader.enable_reloading
    my_filewatcher = Filewatcher.new('backend/')
    Thread.new(my_filewatcher) {|fw| fw.watch {|filename| loader.reload } }
end

loader.setup
