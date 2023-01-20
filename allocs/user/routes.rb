require 'pry'
class App < Roda
    hash_branch 'users' do |r|
        r.get do
            @users = User::DataModel.all.map {|u| User::NameDecorator.new(u)}
            phlex_on(User::Pages::Index.new(users: @users))
        end

        r.on Integer do |id|
            @user = User::NameDecorator.new(User::DataModel[id])
            phlex_on(User::Pages::Show.new(user: @user))
        end
    end
end
