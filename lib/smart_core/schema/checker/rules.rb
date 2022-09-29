# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.8.0
class SmartCore::Schema::Checker::Rules
  require_relative 'rules/type_aliases'
  require_relative 'rules/base'
  require_relative 'rules/result'
  require_relative 'rules/optional'
  require_relative 'rules/required'
  require_relative 'rules/extra_keys'
  require_relative 'rules/options'
  require_relative 'rules/requirement'
  require_relative 'rules/verifier'

  # @since 0.1.0
  include Enumerable

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def initialize
    @rules = {}
    @cache = SmartCore::Engine::Cache.new
  end

  # @param schema_key [String]
  # @param rule [SmartCore::Schema::Checker::Rules::Base]
  # @return [SmartCore::Schema::Checker::Rules::Base]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8..0
  def []=(schema_key, rule)
    cache.clear
    rules[schema_key] = rule
  end

  # @param block [Block]
  # @yield [schema_key, rule]
  # @yieldparam schema_key [String]
  # @yieldparam rule [SmartCore::Schema::Checker::Rules::Base]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def each(&block)
    block_given? ? rules.each_pair(&block) : rules.each_pair
  end

  # @param block [Block]
  # @yield [rule]
  # @yieldparam rule [SmartCore::Schema::Checker::Rules::Base]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def each_rule(&block)
    block_given? ? rules.each_value(&block) : rules.each_value
  end

  # @return [Array<String>]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def keys
    cache.read(:keys) { rules.keys }
  end

  private

  # @return [Hash<String,SmartCore::Schema::Checker::Rules::Base>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :rules

  # @return [SmartCore::Engine::Cache]
  #
  # @api private
  # @since 0.8.0
  attr_reader :cache
end
