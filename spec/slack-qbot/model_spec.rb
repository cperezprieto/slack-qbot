require 'spec_helper'

describe SlackQBot::Model do
  let (:model) { SlackQBot::Model.new }
  let (:user_name) { Faker::Internet.user_name }
  let (:other_user_name) { Faker::Internet.user_name }

  describe '#add_user' do
    context 'when the user is not already in the queue' do
      it "adds the user to the queue" do
        expect{model.add_user(user_name)}.to change{model.queue_size}.from(0).to(1)
      end

      it "returns a success message" do
        expect(model.add_user(user_name)).to eql("Ok <@#{user_name}>, I've added you to the queue!")
      end
    end

    context 'when the user is already in the queue' do
      before { model.add_user(user_name) }

      it "does not add the user to the queue" do
        expect{model.add_user(user_name)}.to_not change{model.queue_size}
      end

      it "returns a failure message" do
        expect(model.add_user(user_name)).to eql("Sorry <@#{user_name}>, you're already in the queue!")
      end
    end

    context 'when the queue has reached maximal size' do
      before do
        SlackQBot::Model::MAX_USERS.times { model.add_user(Faker::Internet.user_name) }
      end

      it "does not add the user to the queue" do
        expect{model.add_user(user_name)}.to_not change{model.queue_size}
      end

      it "returns a failure message" do
        expect(model.add_user(user_name)).to eql("Sorry <@#{user_name}>, max queue size exceeded!")
      end
    end
  end

  describe '#remove_user' do
    context 'when the user is in the queue' do
      before { model.add_user(user_name) }

      it "removes the user from the queue" do
        expect{model.remove_user(user_name)}.to change{model.queue_size}.from(1).to(0)
      end

      it "returns a success message" do
        expect(model.remove_user(user_name)[:message]).to eql("Ok <@#{user_name}>, I've removed you from the queue!")
      end

      context 'when the user is first in the queue' do
        context 'when there is at least one more user in the queue' do
          before { model.add_user(other_user_name) }

          it 'returns the name of the next user' do
            expect(model.remove_user(user_name)[:next_user]).to eql(other_user_name)
          end
        end

        context 'when there are no more users in the queue' do
          it 'does not return a next user name' do
            expect(model.remove_user(user_name)[:next_user]).to be_nil
          end
        end
      end
    end

    context 'when the user is not in the queue' do
      it "does not change the queue size" do
        expect{model.remove_user(user_name)}.to_not change{model.queue_size}
      end

      it "returns a failure message" do
        expect(model.remove_user(user_name)[:message]).to eql("Sorry <@#{user_name}>, I went looking for you but it seems you're not in the queue:\n" + model.generate_queue)
      end
    end
  end

  describe '#generate_queue' do
    context 'when the queue is empty' do
      it "returns 'The queue is currently empty.'" do
        expect(model.generate_queue).to eql('The queue is currently empty.')
      end
    end

    context 'when the queue is not empty' do
      before do
        model.add_user(user_name)
        model.add_user(other_user_name)
      end

      it 'returns a string that contains every user name in the queue' do
        expect(model.generate_queue).to include(user_name)
        expect(model.generate_queue).to include(other_user_name)
      end
    end
  end
end
