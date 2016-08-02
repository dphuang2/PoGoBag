set :stage, :production

# Replace 127.0.0.1 with your server's IP address!
server '146.148.43.226', user: 'deploy', roles: %w{web app db}
