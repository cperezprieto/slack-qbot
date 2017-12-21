module SlackQBot
  module Commands
    class Push < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        if !match['expression']
          client.say(channel: data.channel, text: "Sorry <@#{data.user}> What do you want me to push?")
          return
        end

        parameters = Shellwords.split(match['expression'])
        if !parameters.count.equal? 3
          client.say(channel: data.channel, text: "Sorry <@#{data.user}> Invalid request")
          return
        end

        if !parameters.first.include? ':'
          client.say(channel: data.channel, text: "Sorry <@#{data.user}> Invalid <application>:<branch>")
          return
        end

        if !parameters.second.downcase.eql? 'to'
          client.say(channel: data.channel, text: "Sorry <@#{data.user}> I don't understand you")
          return
        end

        application = parameters.first.split(':').first.strip.tr('`*', '')
        branch = parameters.first.split(':').second.strip.tr('`*', '')
        environment = parameters.third.strip.tr('`*', '')

        app = ApplicationSupport.find_application(application)
        if !app
          client.say(channel: data.channel, text: "Sorry <@#{data.user}>, application `#{application}` not supported")
          return
        else
          if !app.environments.find {|e| e.name == environment }
            client.say(channel: data.channel, text: "Sorry <@#{data.user}>, environment `#{environment}` not recognised " +
                " for Application `#{application}`")
            return
          end
        end

        queue_name = "#{application}-#{environment}"

        if QueueSupport.size(queue_name) >= Work::MAX_WORKS.to_i
          client.say(channel: data.channel, text: "Sorry <@#{data.user}>,
            max queue size #{Work::MAX_WORKS} exceeded. Please, wait for some works to finish!")
          return
        end

        new_work = Work.new(user: data.user, application: application, environment: environment, branch: branch)

        #Send the work to the proper queue
        QueueSupport.push(queue_name, new_work)

        client.say(channel: data.channel, text: "<@#{data.user}> Work `#{new_work.work_id}` added to the queue `#{queue_name}`")

        logger.info "Push: Channel: #{data.channel}, User: #{data.user},  Application: #{application},
          Environment: #{environment}, Branch: #{branch}"
      end
    end
  end
end
