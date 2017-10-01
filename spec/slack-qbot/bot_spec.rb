require 'spec_helper'

describe SlackQBot::Bot do
  let(:app) { SlackQBot::Bot.instance }

  subject { app }

  it_behaves_like 'a slack ruby bot'
end
