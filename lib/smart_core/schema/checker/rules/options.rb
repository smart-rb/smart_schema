# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Options
  require_relative 'options/type'
  require_relative 'options/untyped'

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @type = Untyped.new
    @lock = SmartCore::Engine::Lock.new
  end

  # @return [SmartCore::Schema::Checker::Rules::Options::Type, EmptyValue]
  #
  # @api private
  # @since 0.1.0
  def type
    @lock.synchronize { @type }
  end

  # @return [SmartCore::Schema::Checker::Rules::Options::Type, EmptyValue]
  #
  # @api private
  # @since 0.1.0
  def type=(value)
    @lock.synchronize { @type = value }
  end
end
