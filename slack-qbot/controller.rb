module SlackQBot
  class Controller < SlackRubyBot::MVC::Controller::Base
    def list
      view.say(channel: data.channel, text: model.generate_queue)
    end

    def push
      view.say(channel: data.channel, text: model.push_to(data.user, branch_name, app, environment))
    end

    def remove
      message, next_user = model.remove_user(data.user).values_at(:message, :next_user)
      view.say(channel: data.channel, text: message)

      if next_user
        direct_channel_connection = Slack::Web::Client.new.im_open(user: next_user)
        view.say(channel: direct_channel_connection.channel.id, text: "Hey <@#{next_user}>, you're up!")
      end
    end
  end
end
