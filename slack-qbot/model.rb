require './slack-qbot/available_environment'
require './slack-qbot/available_application'
require './slack-qbot/work'

module SlackQBot
  class Model < SlackRubyBot::MVC::Model::Base
    MAX_WORKS = 20

    AVAILABLE_ENVIRONMENTS = [
        AvailableEnvironment.new('UAT', 'git remote to push to uat'),
        AvailableEnvironment.new('PP', 'git remote to push to pp')
    ]

    AVAILABLE_APPLICATIONS = [
        AvailableApplication.new('GAC', 'git remote for GAC'),
        AvailableApplication.new('GADD', 'git remote for GAddons'),
        AvailableApplication.new('MS1', 'git remote for MySageOne UK')
    ]

    def initialize
      @works = []
    end

    def push_to(user_id, branch_name, target_application, target_environment)
      if !environment.include? AVAILABLE_ENVIRONMENTS.find {|s| s.environment_name == target_environment }
        return "Sorry <@#{user_id}>, environment <#{target_environment}> not recognised."
      end

      if !environment.include? AVAILABLE_APPLICATIONS.find {|s| s.application_name == target_application }
        return "Sorry <@#{user_id}>, application <#{target_application}> not supported."
      end

      if @works.size >= MAX_WORKS
        return "Sorry <@#{user_id}>, max queue size exceeded wait for some works to finish!"
      end

      # if branch_name  Add control to check if branch_name exists in the repo

      new_work = Work.new(user_id, target_application, target_environment, branch_name)
      unless @works.find(new_work)
        @works.push(new_work)
        return "Ok <@#{user_id}>, I've added your work to the queue work id = #{work_id}"
      end

      "Sorry <@#{user_id}>, you're already in the queue!"
    end

    def remove(user_id, work_id)
      output = {message: '', next_user: nil}

      if @works.include?(work_id)


        @works.delete(work_id)
        output[:message] = "Ok <@#{user_id}>, I've removed your work from the queue!"
      else
        output[:message] = "Sorry <@#{user_id}>, I went looking for you but it seems you're not in the queue:\n" + generate_queue
      end

      output
    end

    def queue_size
      @users.size
    end

    def queue_empty?
      @users.empty?
    end

    def generate_queue
      if queue_empty?
        output = 'The queue is currently empty.'
      else
        output = "This is the current queue:\n"
        @users.each_with_index do |user, index|
          output += "> `#{index + 1}º` <@#{user}>\n"
        end
      end

      output
    end
  end
end
