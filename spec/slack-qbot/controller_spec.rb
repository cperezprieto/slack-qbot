require 'spec_helper'

describe SlackQBot::Controller do
  let(:app) { SlackQBot::Bot.instance }
  let(:model) { SlackQBot::Model.new }

  subject { app }

  describe '#show' do
    it 'returns the users queue' do
      expect(message: "#{SlackRubyBot.config.user} show", channel: 'channel').to respond_with_slack_message(model.generate_queue)
    end
  end

  describe '#join' do
    it 'returns a confirmation message' do
      expect(message: "#{SlackRubyBot.config.user} join", channel: 'channel').to respond_with_slack_message("Ok <@user>, I've added you to the queue!")
      expect(message: "#{SlackRubyBot.config.user} join", channel: 'channel').to respond_with_slack_message("Sorry <@user>, you're already in the queue!")
    end
  end

  describe '#leave' do
    it 'returns a confirmation message' do
      expect(message: "#{SlackRubyBot.config.user} leave", channel: 'channel').to respond_with_slack_message("Ok <@user>, I've removed you from the queue!")
      expect(message: "#{SlackRubyBot.config.user} leave", channel: 'channel').to respond_with_slack_message("Sorry <@user>, I went looking for you but it seems you're not in the queue:\n" + model.generate_queue)
    end
  end
end
