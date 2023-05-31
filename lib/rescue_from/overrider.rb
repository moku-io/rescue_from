require 'active_support/core_ext/module/attribute_accessors'

module RescueFrom
  module Overrider
    def handlers
      @handlers ||= {}
    end

    # rubocop:disable Style/CaseEquality
    def handler_for exception
      handlers
        .find { |pattern, _handler| pattern === exception }
        &.last
    end
    # rubocop:enable Style/CaseEquality
  end
end
