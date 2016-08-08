set :stage, :production

server '45.79.90.230', user: 'deploy', roles: %w{web app db}
