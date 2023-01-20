module User
    module Components
        class Card < Phlex::HTML
            def initialize(id: 0,name: "John Doe", title: "Architect & Engineer")
                @id, @name, @title = id, name, title
            end
            def template
                div(class: 'card') do
                    img(src: "https://gravatar.com/avatar/49528f9d290efa1ce1be0b3fe2a94863?s=400&d=robohash&r=x", alt: 'avatar', style: 'width:100%')
                    div(class: 'container') do
                        h4 do
                            b{ @name }
                        end
                        p{ @title }
                        render Shared::Components::StimController.new(name: 'hello') do
                            input(type: 'text', data: {hello_target: 'name'})
                            button(data: {action: 'click->hello#greet'}){"Greet"}
                        end
                    end
                render User::Components::HxButton.new(id: @id)
                end
            end
        end
    end
end
