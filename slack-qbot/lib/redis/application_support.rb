require 'json'
require 'redis'

module SlackQBot
  class ApplicationSupport

    @redis = Redis.respond_to?(:connect) ? Redis.connect : Redis.new

    def self.application_key(application_name)
      "application:#{application_name}"
    end

    def self.add_application(application)
      @redis.rpush(application_key(application.name), application.to_json)
    end

    def self.list(application_name = nil)
      application_array = []
      list_all_applications.each do |redis_applications|
        redis_array = @redis.lrange(redis_applications, 0, - 1)
        redis_array.each do |redis_application|
          application_array.append(Application.new.from_hash(JSON.parse(redis_application, :create_additions => true)))
        end
      end

      return application_array.select { |a| a.name == application_name } if application_name
      return application_array
    end

    def self.application_exist?(application_name)
      return true if list(application_name).size > 0
      return false
    end

    def self.has_environment?(application_name, environment_name)
      find_application(application_name).environments.each do |e|
        return true if e.name == environment_name
      end
      return false
    end

    def self.find_application(application_name)
      list.select do |a|
        return a if a.name == application_name
      end
      return nil
    end

    private
    def self.list_all_applications
      @redis.keys('application:*')
    end

    def self.remove_application(application)
      @redis.lrem(application_key(application.name), 1, application.to_json)
    end

    def self.add_environment(application_name, environment)
      application = find_application(application_name)
      remove_application(application)
      application.environments.append(environment)
      add_application(application)
    end

    def self.remove_environment(application_name, environment_name)
      application = find_application(application_name)
      remove_application(application)
      add_application(application.environments.delete_if { |e| e.name == environment_name })
    end

    def self.get_environment(application_name, environment_name)
      application = find_application(application_name)
      application.environments.each do |e|
        return e if e.name == environment_name
      end
      return nil
    end
  end
end
