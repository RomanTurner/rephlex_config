require 'dotenv/load'
Dotenv.load
dev = ENV['RACK_ENV'] == 'development'

if dev
    require 'logger'
    logger = Logger.new($stdout)
end

require 'rack/unreloader'
Unreloader = Rack::Unreloader.new(handle_reload_errors: true, subclasses: %w'Roda Sequel::Model', logger: logger, reload: dev){App}

Dir["allocs/shared/layouts"].each do |layouts|
    require_relative layouts
end

require_relative 'models'
Unreloader.require './models.rb'
Unreloader.require('app.rb'){'App'}
run(dev ? Unreloader : App.freeze.app)


require 'phlex'
require 'vite_ruby'
require_relative 'vite_rephlex'

# To configure vite_tag helpers with phlex components.
# I want to make them availible to all the components in the library.
# todo:  I could abstract this into a gem vite_rephlex or vite_phlex
Phlex::HTML.include(ViteRephlex)
