require 'spec_helper'

describe SlackQBot::Model do
  let (:model) { SlackQBot::Model.new }
  # let (:user_name) { Faker::Internet.user_name }
  # let (:other_user_name) { Faker::Internet.user_name }

  describe 'When the queue is empty' do
    it 'return empty method to true' do
      expect(SlackQBot::Model.new.queue_empty?).to be true
    end
  end

end
