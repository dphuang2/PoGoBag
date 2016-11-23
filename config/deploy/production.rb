set :stage, :production

server '97.107.142.163', user: 'deploy', roles: %w{web app db}
