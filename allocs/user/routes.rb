class App < Roda
    hash_branch 'users' do |r|
        r.get true do
            User::DataModel.all.to_s
        end

        r.on Integer do |id|
            @user = User::DataModel[id]
            "Hi from user #{id}, my first name is #{@user.first_name}"
        end
    end
end
