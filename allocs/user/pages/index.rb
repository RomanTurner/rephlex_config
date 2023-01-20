module User
    module Pages
        class Index < Phlex::HTML
            def initialize(users:)
                @users = users
            end
            def template
                div(class: 'grid-container') do
                    @users.each do |user|
                        div(class: 'grid-item') do
                            render User::Components::Card.new(
                                id: user.id,
                                name: user.name,
                                title: user.title
                            )
                        end
                    end
                end
            end
        end
    end
end
