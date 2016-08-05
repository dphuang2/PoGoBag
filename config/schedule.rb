set :environment, :development
set :output, "log/whenever.log"
every 1.minute do
  runner "User.refresh_pokemon"
end
