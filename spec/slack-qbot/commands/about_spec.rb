require 'spec_helper'

describe SlackQBot::Commands::Default do
  def app
    SlackQBot::Bot.instance
  end
  it 'qbot' do
    expect(message: 'qbot').to respond_with_slack_message(SlackMathbot::ABOUT)
  end
  it 'Qbot' do
    expect(message: 'Qbot').to respond_with_slack_message(SlackMathbot::ABOUT)
  end
end
