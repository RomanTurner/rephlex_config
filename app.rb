require 'roda'

class App < Roda
    plugin :h
    plugin :hash_branches


    logger = if ENV['RACK_ENV'] == 'test'
        Class.new{def write(_) end}.new
    else
        $stderr
    end
    plugin :common_logger, logger


    Dir["backend/**/routes.rb"].each do |route_file|
        require_relative route_file
    end

    route do |r|
        r.root do
            "Welcome home"
        end

        r.get "hello" do
            h User::DataModel.first
        end

        r.hash_branches
    end
end
