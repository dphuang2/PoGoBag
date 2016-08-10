set :stage, :production

server '192.99.201.34', user: 'deploy', roles: %w{web app db}
