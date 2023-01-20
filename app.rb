require 'roda'

class App < Roda
    # Application Plugins
    plugin :hash_branches

    # Load Custom Plugins
    Dir["roda_plugins/*"].each do |route_file|
        require_relative route_file
    end
    plugin :phlex, layout: Shared::Layout::Homepage

    #! plugin :vite_rephlex,
    #* if we preconfigure the application js, stylesheet, and client tag we
    #* can just offer additional configuration with an add_to_head:
    #* option for vite_rephlex plugin

    #todo[x]: look at the vite_rails tag_helpers for examples.
    #* Most of it is assets on the server, we can easily use
    #* cloudinary for images instead so I don't know if I want to set that up yet

    #todo[x]: Setup HTMX
    #todo[x]: Setup Stimulus.js
    #todo: Setup Tailwind.css

    #* I figure if anyone wants to help out with the Stimulus Reflex or TurboReflex crew
    #* They will know better than me to set it up. We will have Vite up and running and
    #* That should be good enough for anyone to get configuring.

    #? How is HMR going to run with Zeitwerk reloading?
    #* Currently not a big thought until we want autoreloading stimulus controllers.

    # Configure Default Layout
    Dir["allocs/shared/layouts"].each do |layouts|
        require_relative layouts
    end

    # Configure Logger
    logger = if ENV['RACK_ENV'] == 'test'
        Class.new{def write(_) end}.new
    else
        $stderr
    end
    plugin :common_logger, logger

    # Load Routes
    Unreloader.require("allocs/**/routes.rb", :delete_hook=>proc{|f| hash_branch(File.basename(f).delete_suffix('.rb'))}){}

    route do |r|
        r.root do
            phlex_on(
                Shared::Pages::Hello.new(Struct.new(:first_name).new('bob')),
                layout_options: {title: "Phlex Test"}
              )
        end

        r.post 'clicked' do
            User::Components::Sidebar.new.call
        end

        r.get 'testing' do
            "Hi"
        end

        r.get "hello" do
            phlex_on(
                Shared::Pages::Hello.new(User::DataModel.first),
                layout_options: {title: "User Hello"}
            )
        end

        r.hash_branches
    end
end
