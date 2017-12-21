module SlackQBot
  module Commands
    class Delete < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        if !match['expression']
          client.say(channel: data.channel, text: "Sorry <@#{data.user}> What application do you want me to delete?")
          return
        end

        parameters = Shellwords.split(match['expression'])

        name = parameters.first.strip.tr('`*', '')

        application = ApplicationSupport.find_application(name)
        if !application
          client.say(channel: data.channel, text: "Sorry <@#{data.user}>, application `#{name}` not found")
          return
        end

        ApplicationSupport.remove_application(application)
        client.say(channel: data.channel, text: "<@#{data.user}> Application `#{name}` deleted")

        logger.info "Delete: Channel: #{data.channel}, User: #{data.user},  Name: #{name}"
      end
    end
  end
end
