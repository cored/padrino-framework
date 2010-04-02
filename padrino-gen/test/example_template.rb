project :test => :rspec, :orm => :activerecord

generate :model, "post title:string body:text"
generate :controller, "posts get:index get:new post:new"
generate :migration, "AddEmailToUser email:string"
generate :fake, "foo bar"

require_dependencies 'nokogiri'

inject_into_file "app/models/post.rb","#Hello", :after => "end\n"

initializer :test, "#Hello"

app :testapp do
  generate :controller, "users get:index"
end