set :output, "#{path}/log/cron.log"

every 2.minutes do
  rake 'refresh_data'
end
