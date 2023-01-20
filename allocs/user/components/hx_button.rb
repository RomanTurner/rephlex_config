module User
    module Components
        class HxButton < Phlex::HTML
            def initialize(id: 0)
                @id = id
            end
            def template
                div(id: "parent-div-#{@id}") do
                    button(hx: {
                                trigger: 'click',
                                post: '/clicked',
                                target: "#parent-div-#{@id}",
                                swap: 'outerHTML'
                                }
                          ){"Click Me!"}
                end
            end
        end
    end
end
