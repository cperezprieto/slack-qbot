module SlackQBot
  module Commands
    class Create < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        if !match['expression']
          client.say(channel: data.channel, text: "Sorry <@#{data.user}> What application do you want me to create?")
          return
        end

        parameters = Shellwords.split(match['expression'])
        if !parameters.count.equal? 2
          client.say(channel: data.channel, text: "Sorry <@#{data.user}> Invalid request")
          return
        end

        name = parameters.first.strip.tr('`*', '')
        repository = parameters.second.strip.tr('`*', '')

        if ApplicationSupport.find_application(name)
          client.say(channel: data.channel, text: "Sorry <@#{data.user}>, application `#{name}` already exists")
          return
        end

        application = Application.new(name: name, repository: repository)
        ApplicationSupport.add_application(application)
        client.say(channel: data.channel, text: "<@#{data.user}> Application `#{application.name}` created")

        logger.info "Add: Channel: #{data.channel}, User: #{data.user},  Name: #{name},
          Repository: #{repository}"
      end
    end
  end
end
