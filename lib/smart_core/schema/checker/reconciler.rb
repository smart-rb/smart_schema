# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Reconciler
  require_relative 'reconciler/factory'

  class << self
    # @param definitions [Proc]
    # @return [SmartCore::Schema::Checker::Reconciler]
    #
    # @api private
    # @since 0.1.0
    def create(definitions)
      SmartCore::Schema::Checker::Reconciler::Factory.create(definitions)
    end
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @rules = {}
    @lock = SmartCore::Engine::Lock.new
  end

  # @param schema_key [String, Symbol]
  # @param nested_definitions [Block]
  # @return [SmartCore::Schema::Checker::Rules::Required]
  #
  # @api private
  # @since 0.1.0
  def required(schema_key, &nested_definitions)
    thread_safe do
      rule = SmartCore::Schema::Checker::Rules::Required.new(schema_key, &nested_definitions)
      rule.tap { rules[rule.schema_key] = rule }
    end
  end

  # @param schema_key [String, Symbol]
  # @param nested_definitions [Block]
  # @return [SmartCore::Schema::Checker::Rules::Optional]
  #
  # @api private
  # @since 0.1.0
  def optional(schema_key, &nested_definitions)
    thread_safe do
      rule = SmartCore::Schema::Checker::Rules::Optional.new(schema_key, &nested_definitions)
      rule.tap { rules[rule.schema_key] = rule }
    end
  end

  private

  # @return [Hash<String,SmartCore::Schema::Checker::Rules::Base]
  #
  # @api private
  # @since 0.1.0
  attr_reader :rules

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
