module Shared
	module Layout
		class Homepage < Phlex::HTML
			attr_accessor :current_head

			class Empty < Phlex::HTML
				def template
					""
				end
			end

			def initialize(component, title:)
			  @title = title
			  @current_head = []
			  @component = component || Empty.new
			end

			def template
			  html do
				head do
				  meta(charset: "UTF-8")
				  meta("http-equiv" => "UTF-8", content: "IE=edge")
				  meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
				  render vite_javascript_tag('application')
				  render vite_client_tag
				  compose_head
				  title { @title }
				end

				body do
				  render @component
				end
			  end
			end

		private

			def compose_head
			  if !current_head.empty?
				current_head.each do |el|
					render el
				end
			  end
			end
		end
	end
end
