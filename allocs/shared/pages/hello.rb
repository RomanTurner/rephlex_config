module Shared
    module Pages
        class Hello < Phlex::HTML
            def initialize(user)
                @user = user
            end

            def template
                h1{"Hello #{@user.first_name.capitalize}"}
            end
        end
    end
end
