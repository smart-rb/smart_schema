# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Options
  require_relative 'options/empty'
  require_relative 'options/type'
  require_relative 'options/filled'

  # @param rule [SmartCore::Schema::Checker::Rules::Base]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(rule)
    @type = Empty.new(rule)
    @filled = Empty.new(rule)
    @lock = SmartCore::Engine::Lock.new
  end

  # @return [SmartCore::Schema::Checker::Rules::Options::Type]
  # @return [SmartCore::Schema::Checker::Rules::Options::Empty]
  #
  # @api private
  # @since 0.1.0
  def type
    @lock.synchronize { @type }
  end

  # @param option [SmartCore::Schema::Checker::Rules::Options::Type]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def type=(option)
    @lock.synchronize { @type = option }
  end

  # @return [SmartCore::Schema::Checker::Rules::Options::Filled]
  # @return [SmartCore::Schema::Checker::Rules::Options::Empty]
  #
  # @api private
  # @since 0.1.0
  def filled
    @lock.synchronize { @filled }
  end

  # @param option [SmartCore::Schema::Checker::Rules::Options::Filled]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def filled=(option)
    @lock.synchronize { @filled = option }
  end
end
