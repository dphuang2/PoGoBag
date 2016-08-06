set :output, "#{path}/log/cron.log"

every 1.minute do
  rake 'refresh_data'
end
