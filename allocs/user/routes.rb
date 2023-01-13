class App < Roda
    hash_branch 'user' do |r|
        r.get true do
            h User::DataModel.all
        end

        r.on Integer do |id|
            @user = User::DataModel[id]
            "Hi from user #{id}, my first name is #{@user.first_name}"
        end
    end
end
