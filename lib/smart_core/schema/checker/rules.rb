# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules
  require_relative 'rules/type_aliases'
  require_relative 'rules/base'
  require_relative 'rules/optional'
  require_relative 'rules/required'
  require_relative 'rules/extra_keys'
  require_relative 'rules/options'
  require_relative 'rules/verifier'

  # @since 0.1.0
  include Enumerable

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @rules = {}
    @lock = SmartCore::Engine::Lock.new
  end

  # @param schema_key [String]
  # @return [SmartCore::Schema::Checker::Rules::Base]
  #
  # @api private
  # @since 0.1.0
  def [](schema_key)
    thread_safe do
      begin
        rules.fetch(schema_key)
      rescue KeyError
        raise(SmartCore::Schema::UnaccceptableSchemaKeyError, <<~ERROR_MESSAGE)
          TODO: нормальный эррор-меседж что ключ не описа в схеме
        ERROR_MESSAGE
      end
    end
  end

  # @param schema_key [String]
  # @param rule [SmartCore::Schema::Checker::Rules::Base]
  # @return [SmartCore::Schema::Checker::Rules::Base]
  #
  # @api private
  # @since 0.1.0
  def []=(schema_key, rule)
    thread_safe { rules[schema_key] = rule }
  end

  # @param block [Block]
  # @yield [schema_key, rule]
  # @yieldparam schema_key [String]
  # @yieldparam rule [SmartCore::Schema::Checker::Rules::Base]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each(&block)
    thread_safe { block_given? ? rules.each_pair(&block) : rules.each_pair }
  end

  # @param block [Block]
  # @yield [rule]
  # @yieldparam rule [SmartCore::Schema::Checker::Rules::Base]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each_rule(&block)
    thread_safe { block_given? ? rules.each_value(&block) : rules.each_value }
  end

  # @return [Array<String>]
  #
  # @api private
  # @since 0.1.0
  def keys
    thread_safe { rules.keys }
  end

  protected

  # @return [Hash<String,SmartCore::Schema::Checker::Rules::Base>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :rules

  private

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
