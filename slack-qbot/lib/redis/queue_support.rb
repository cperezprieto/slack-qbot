require 'json'
require 'redis'

module SlackQBot
  class QueueSupport

    @redis = Redis.respond_to?(:connect) ? Redis.connect : Redis.new

    def self.queue_key(queue_name)
      "queue:#{queue_name}"
    end

    def self.push(queue_name, work)
      @redis.rpush(queue_key(queue_name), work.to_json)
    end

    def self.pop(queue_name)
      Work.new.from_hash(JSON.parse(@redis.lpop(queue_key(queue_name)), create_additions: true))
    end

    def self.size(queue_name)
      @redis.llen(queue_key(queue_name)).to_i
    end

    def self.list(queue_name = nil)
      queue_array = []
      list_all_queues.each do |redis_queue|
        new_queue = Queue.new(name: redis_queue.gsub('queue:', ''))
        redis_array=@redis.lrange(redis_queue, 0, size(redis_queue) - 1)
        redis_array.each do |work|
          new_queue.works.append(Work.new.from_hash(JSON.parse(work, :create_additions => true)))
        end
        queue_array.append(new_queue)
      end

      return queue_array.select { |q| q.name == queue_name } if queue_name
      return queue_array
    end

    private
    def self.list_all_queues
      @redis.keys('queue:*')
    end

    def self.queue_exist?(queue_name)
      list_all_queues.select { |q| return true if q == queue_key(queue_name) }
      return false
    end

    def self.work_exist?(work_id)
      return true if find_work(work_id)
      return false
    end

    def self.find_work(work_id)
      list.select do |q|
        q.works.each { |w| return w if w.work_id == work_id}
      end
      return nil
    end

    def self.find_work_queue(work_id)
      list.each do |q|
        q.works.each do |w|
          return q.name if  w.work_id == work_id
        end
      end
      return nil
    end

    def self.remove_work(work)
      queue_name = find_work_queue(work.work_id)
      @redis.lrem(queue_key(queue_name), 1, work.to_json)
    end
  end
end
