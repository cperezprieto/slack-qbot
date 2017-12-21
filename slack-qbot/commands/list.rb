module SlackQBot
  module Commands
    class List < SlackRubyBot::Commands::Base
      def self.call(client, data, match)

        parameters = Shellwords.split(match['expression']).first if match['expression']

        case parameters
          when 'applications'
            application_list = ApplicationSupport.list.map.with_index { |a, index| "    *#{index + 1}. Name:* `#{a.name}`" +
                " *Repository:* `#{a.repository}` *Environments:*\n #{a.environments.map { |e| "`#{e.name}` - " +
                    " `#{e.remote}`"}.join("\n")}"}.join("\n")
            client.say(channel: data.channel, text: ":information_source: Supported applications:\n #{application_list}")
          when 'queues'
            if QueueSupport.list.size > 0
              queues_list = QueueSupport.list.map.with_index { |q, index| "*#{index + 1}. Name:* `#{q.name}`"}.join("\n")
              client.say(channel: data.channel, text: ":information_source: List of current queues:\n #{queues_list}")
            else
              client.say(channel: data.channel, text: ':information_source: No queues found')
            end
          else
            all_queues_list = QueueSupport.list(parameters)
            if all_queues_list.size == 0
              client.say(channel: data.channel, text: ':information_source: No pending works')
              return
            end

            full_list_string = ''
            all_queues_list.each do |q|
              full_list_string << "*Queue:* `#{q.name}`: \n"
              full_list = q.works.map.with_index { |w, index| ">*#{index + 1}. Id:* `#{w.work_id}`" +
                  "  *User:* `#{ client.users[data.user].real_name}`  *Application:* `#{w.application}`" +
                  "  *Branch:* `#{w.branch}`  *Environment:* `#{w.environment}`" +
                  "  #{':spinner:' if w.status == :in_progress  }" }.join("\n")
              full_list_string << full_list << "\n"
            end

            client.say(channel: data.channel, text: "#{full_list_string}")
        end

        logger.info "List: Channel: #{data.channel}, User: #{data.user}"
      end
    end
  end
end
