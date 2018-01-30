require 'timeout'

module SlackQBot
  class QueueWorker
    def initialize
      while true
        QueueSupport.list.each do |queue|
          work = queue.works&.first
          puts work.status
          if work.status == 'pending'
            Thread.new {
              begin
                Timeout.timeout(3600) {
                  work.status = 'in_progress'
                  QueueSupport.update_work(work)

                  # Logic to push
                  puts work.inspect

                  # Locate Application from work.application
                  application = ApplicationSupport.find_application(work.application)

                  # Locate Application.environment where Environment.name = work.environment
                  environment = application.environments.select { |e| e.name = work.environment }.first

                  # Instance a new Repository class to manage the push
                  repository = Repository.new(remote_repo: application.repository)
                  repository.push?(remote: environment.remote, branch: work.branch)

                  # Remove work from Queue
                  QueueSupport.remove_work(work)
                }
              rescue => e
                puts "Error Handling: #{e}"
                # Send message to the user

                # Remove work from Queue
                QueueSupport.remove_work(work)
              end
            }
          end
        end
        sleep(5)
      end
    end
  end
end