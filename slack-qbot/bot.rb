module SlackQBot
  class Bot < SlackRubyBot::Bot
    help do
      title 'QBot'
      desc 'This bot manages a queue of user request.'

      command 'list' do
        desc 'Shows the current pending requests queue.'
      end

      command 'push <branch_name> from <app> to <environment>' do
        desc 'Adds your work to the UAT queue. You will get pinged when you reach the front.'
      end

      command 'remove <queue_id>' do
        desc 'Removes your work from the queue.'
      end
    end

    model = Model.new
    view = View.new

    @controller = Controller.new(model, view)
  end
end
