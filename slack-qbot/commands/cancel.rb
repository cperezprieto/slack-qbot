module SlackQBot
  module Commands
    class Cancel < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        if !match['expression']
          client.say(channel: data.channel, text: "Sorry <@#{data.user}> What work do you want me to cancel?")
          return
        end

        parameters = Shellwords.split(match['expression'])

        work_id = parameters.first.strip.tr('`*', '')
        work = QueueSupport.find_work(work_id)

        if !work
          client.say(channel: data.channel, text: "Sorry <@#{data.user}> Work `#{work_id}` not found")
          return
        end

        if work.user != data.user
          client.say(channel: data.channel, text: "Sorry <@#{data.user}> Work `#{work_id}` doesn't belong to you")
          return
        end

        QueueSupport.remove_work(work)
        client.say(channel: data.channel, text: "<@#{data.user}> Work `#{work_id}` canceled")
      end
    end
  end
end
