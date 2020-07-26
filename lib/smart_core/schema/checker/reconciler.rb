# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Reconciler
  require_relative 'reconciler/factory'
  require_relative 'reconciler/collate'

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
    @rules = SmartCore::Schema::Checker::Rules.new
    @lock = SmartCore::Engine::Lock.new
  end

  # @param verifiable_hash [Hash<String|Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def __collate!(verifiable_hash)
    thread_safe { SmartCore::Schema::Checker::Reconciler::Collate.call(verifiable_hash, rules) }
  end

  # @param schema_key [String, Symbol]
  # @param nested_definitions [Block]
  # @return [SmartCore::Schema::Checker::Rules::Required]
  #
  # @api public
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
  # @api public
  # @since 0.1.0
  def optional(schema_key, &nested_definitions)
    thread_safe do
      rule = SmartCore::Schema::Checker::Rules::Optional.new(schema_key, &nested_definitions)
      rule.tap { rules[rule.schema_key] = rule }
    end
  end

  private

  # @return [SmartCore::Schema::Checker::Rules]
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
