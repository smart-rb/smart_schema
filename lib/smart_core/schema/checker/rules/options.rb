# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Options
  require_relative 'options/empty'
  require_relative 'options/type'
  require_relative 'options/filled'

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @type = Empty.new
    @filled = Empty.new
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
