require 'therefore'
require_relative "rescue_from/version"

module RescueFrom
  class Error < StandardError; end
end

require_relative 'rescue_from/rescuable'
