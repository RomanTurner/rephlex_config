module Shared
    module Components
        class StimController < Phlex::HTML
            def initialize(name:)
                @name = name
            end
            def template
                div(data: {controller: @name})do
                    yield
                end
            end
        end
    end
end
