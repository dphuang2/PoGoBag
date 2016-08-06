set :output, "#{path}/log/cron.log"

job_type :custom_runner,  
  "cd :path && bundle exec rails runner -e :environment ':task' :output"
every 1.minute do
  custom_runner "User.scheduled_refresh"
end
