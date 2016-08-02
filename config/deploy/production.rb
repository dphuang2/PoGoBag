set :stage, :production

server '146.148.43.226', user: 'deploy', roles: %w{web app db}
