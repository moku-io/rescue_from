require_relative 'overrider'

module RescueFrom
  module Rescuable
    def self.extended base
      overrider = Module.new do
        extend Overrider
      end

      base.const_set :RescueFrom_Overrider, overrider
      base.prepend overrider
    end

    def inherited subclass
      super

      puts 'inside the inherited'

      subclass.extend Rescuable
    end

    def rescue_from *patterns, &handler
      raise ArgumentError, 'always provide a handler when calling rescue_from' unless block_given?

      overrider = const_get :RescueFrom_Overrider

      patterns.each do |pattern|
        overrider.handlers[pattern] = handler
      end
    end

    def should_rescue_in? _method_name
      true
    end

    def method_added name
      super

      return unless should_rescue_in? name

      overrider = const_get :RescueFrom_Overrider

      return if overrider.method_defined? name

      # rubocop:disable Lint/RescueException
      overrider.define_method name do |*args, **kwargs, &block|
        super(*args, **kwargs, &block)
      rescue Exception => e
        self.class
          .ancestors
          .lazy
          .filter_map { |mod| mod.const_get :RescueFrom_Overrider if mod.const_defined? :RescueFrom_Overrider }
          .filter_map { |ancestor_overrider| ancestor_overrider.handler_for e }
          .first
          .otherwise { raise e }
          .therefore { |handler| handler.call e }
      end
      # rubocop:enable Lint/RescueException
    end
  end
end
