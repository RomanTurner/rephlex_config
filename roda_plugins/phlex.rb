class Roda
  module RodaPlugins
    module Phlex
      def self.configure(app, opts)
        app.opts[:class_name] = app.name
        app.opts[:phlex] = opts
      end

      module InstanceMethods
        # Render a component with the default layout.
        # You can change out the layout per render basis, so you are not trapped
        # With the configurations. You may also send options to the layouts themselves.
        def phlex_on(component, layout: opts[:phlex][:layout], layout_options: {})
          title = layout_options[:title] || opts[:class_name]
          layout.new(component, title: title).call
        end

        def phlex_layout
          opts[:phlex][:layout]
        end

        def phlex_add_to_head(head)
          current_head = opts[:phlex][:layout].current_head
          if head.kind_of?(Array)
            current_head.concat(head)
          else
            current_head << head
          end
        end
      end
    end

    register_plugin :phlex, Phlex
  end
end
