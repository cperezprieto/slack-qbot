module SlackQBot
  module Commands
    class Remote < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        if !match['expression']
          client.say(channel: data.channel, text: "Sorry <@#{data.user}> What application do you want me to do?")
          return
        end

        parameters = Shellwords.split(match['expression'])
        if !(parameters.count > 2)
          client.say(channel: data.channel, text: "Sorry <@#{data.user}> Invalid request")
          return
        end

        application_name = parameters.second.strip.tr('`*', '')
        name = parameters.third.strip.tr('`*', '')

        application = ApplicationSupport.find_application(application_name)
        if !application
          client.say(channel: data.channel, text: "Sorry <@#{data.user}>, application `#{application_name}` doesn't exists")
          return
        end

        case parameters.first
          when 'add'
            if !parameters.fourth
              client.say(channel: data.channel, text: "Sorry <@#{data.user}>, you forget to indicate the remote")
              return
            end

            remote = parameters.fourth.strip.tr('`*', '')

            if application.environments.find { |e| e.name == name}
              client.say(channel: data.channel, text: "Sorry <@#{data.user}>, environment `#{name}` already exists for #{application_name}")
              return
            end

            environment = Environment.new(name: name, remote: remote)
            ApplicationSupport.add_environment(application.name, environment)
            client.say(channel: data.channel, text: "<@#{data.user}> environment `#{name}` added to `#{application_name}`")

          when 'delete' #Error: undefined method `name' for #<Array:0x00000003ec63c0> (NoMethodError)

            environment = ApplicationSupport.get_environment(application.name, name)

            if !environment
              client.say(channel: data.channel, text: "<@#{data.user}> environment `#{name}` not found in `#{application_name}`")
              return
            end

            ApplicationSupport.remove_environment(application.name, environment)
            client.say(channel: data.channel, text: "<@#{data.user}> environment `#{name}` added to `#{application_name}`")
        end

        logger.info "Remote: Channel: #{data.channel}, Action: #{parameters.first} User: #{data.user}
           ApplicationName: #{application_name} Name: #{name} Remote: #{remote}"
      end
    end
  end
end
