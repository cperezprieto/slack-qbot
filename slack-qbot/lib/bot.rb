require 'yaml'

module SlackQBot
  class Bot < SlackRubyBot::Bot
    application_list = YAML.load_file('./slack-qbot//lib/applications.yaml')
    application_list.each do |a|
      ApplicationSupport.add_application(a)
    end

    Thread.new { QueueWorker.new }
  end
end
