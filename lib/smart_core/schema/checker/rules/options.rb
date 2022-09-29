# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.8.0
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
  end

  # @return [SmartCore::Schema::Checker::Rules::Options::Type]
  # @return [SmartCore::Schema::Checker::Rules::Options::Empty]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def type
    @type
  end

  # @param option [SmartCore::Schema::Checker::Rules::Options::Type]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def type=(option)
    @type = option
  end

  # @return [SmartCore::Schema::Checker::Rules::Options::Filled]
  # @return [SmartCore::Schema::Checker::Rules::Options::Empty]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def filled
    @filled
  end

  # @param option [SmartCore::Schema::Checker::Rules::Options::Filled]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def filled=(option)
    @filled = option
  end
end
