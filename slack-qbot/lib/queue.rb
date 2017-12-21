module SlackQBot
  class Queue
    attr_accessor :name, :works

    def initialize (name: nil, works:[])
      @name = name
      @works = works
    end
  end
end
