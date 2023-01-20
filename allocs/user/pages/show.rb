module User
    module Pages
        class Show < Phlex::HTML
            def initialize(user:)
                @user = user
            end
            def template
                render User::Components::Card.new(name: @user.name, title: @user.title)
            end
        end
    end
end
