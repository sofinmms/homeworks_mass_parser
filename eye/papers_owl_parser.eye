WORKERS = 1
APP_NAME = 'papers_owl_parser'

Eye.application "homeworks_mass_parsers.#{APP_NAME}" do

    working_dir File.expand_path("../../", __FILE__)
    env 'BUNDLE_GEMFILE' => self.working_dir + "/Gemfile"

   group :workers do
      chain grace: 1.seconds
         WORKERS.times do |n|
            process "worker_#{n}" do
                stdall File.join('logs',"#{APP_NAME}_#{n}.log")
                pid_file File.join('tmp', "#{APP_NAME}_#{n}.pid")

                start_command "nice bin/run #{APP_NAME} --log_level=INFO --log_filename=#{APP_NAME}_log_#{n}.log"
                stop_command 'kill -TERM {PID}'

                daemonize true
                stop_on_delete true

                check :memory, every: 20.seconds, below: 200.megabytes, times: 3
            end
        end
    end
end
