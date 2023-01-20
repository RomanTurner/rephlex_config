require 'delegate'
module User
    class NameDecorator < DelegateClass(User::DataModel)
        def name
            "#{first_name} #{last_name}"
        end
        def title
            "The Thick One."
        end
    end
end
