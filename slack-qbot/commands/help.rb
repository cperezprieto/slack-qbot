module SlackQBot
  module Commands
    class Help < SlackRubyBot::Commands::Base
      HELP = <<-EOS.freeze
*help* - get this helpful message

*list* - get the current list of pending works. If <queue_name> is passed shows the pending works for the queue
                    *list `<queue_name?>`*
                      - qbot list
                      - qbot list GAC-UAT

*list queues* - get the current list of queues
                      - qbot list queues

*push* - add a new work to the queue 
                    *push* `<application>`*:*`<branch_name>` *to* `<environment>`
                      - qbot push `GAC`:`master` to `UAT`

*cancel* - remove a pending work from the queue 
                    *cancel* `<work_id>`
                      - qbot remove `#{SecureRandom.hex(4)}`

EOS
      HELP_CONFIG = <<-EOS.freeze
:warning: Only use this commands if you know what you're doing
*create* - create a new application
                    *create* `<application_name>` `<github_source>`

*delete* - delete an application
                    *delete* `<application_name>`

*remote add* - add a new environment to application
                    *remote add* `<application_name>` `<environment_name>` `<remote>`

*remote delete* - delete a environment from application
                    *remote delete* `<application_name>` `<environment_name>`

*list applications* - list all the supported applications

EOS
      def self.call(client, data, match)
        if !match['expression']
          client.say(channel: data.channel, text: [HELP])
        else
          parameters = Shellwords.split(match['expression'])
          if parameters.first.strip.tr('`*', '').eql? 'configuration'
            client.say(channel: data.channel, text: [HELP_CONFIG])
          else
            client.say(channel: data.channel, text: "Sorry <@#{data.user}>, I don't understand you")
          end
        end

        logger.info "HELP: channel=#{data.channel}, user=#{data.user}"
      end
    end
  end
end
