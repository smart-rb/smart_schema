# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules
  require_relative 'rules/base'
  require_relative 'rules/optional'
  require_relative 'rules/required'
  require_relative 'rules/options'

  # @since 0.1.0
  include Enumerable

  # TODO: use smart_type-system
  TYPE_ALIASES = {
    'value.any'         => SmartCore::Types::Value::Any,
    'value.nil'         => SmartCore::Types::Value::Nil,
    'value.string'      => SmartCore::Types::Value::String,
    'value.symbol'      => SmartCore::Types::Value::Symbol,
    'value.text'        => SmartCore::Types::Value::Text,
    'value.integer'     => SmartCore::Types::Value::Integer,
    'value.float'       => SmartCore::Types::Value::Float,
    'value.numeric'     => SmartCore::Types::Value::Numeric,
    'value.big_decimal' => SmartCore::Types::Value::BigDecimal,
    'value.boolean'     => SmartCore::Types::Value::Boolean,
    'value.array'       => SmartCore::Types::Value::Array,
    'value.hash'        => SmartCore::Types::Value::Hash,
    'value.proc'        => SmartCore::Types::Value::Proc,
    'value.class'       => SmartCore::Types::Value::Class,
    'value.module'      => SmartCore::Types::Value::Module,
    'value.tme'         => SmartCore::Types::Value::Time,
    'value.date_time'   => SmartCore::Types::Value::DateTime,
    'value.date'        => SmartCore::Types::Value::Date,
    'value.time_based'  => SmartCore::Types::Value::TimeBased,
    'any'               => SmartCore::Types::Value::Any,
    'nil'               => SmartCore::Types::Value::Nil,
    'string'            => SmartCore::Types::Value::String,
    'symbol'            => SmartCore::Types::Value::Symbol,
    'text'              => SmartCore::Types::Value::Text,
    'integer'           => SmartCore::Types::Value::Integer,
    'float'             => SmartCore::Types::Value::Float,
    'numeric'           => SmartCore::Types::Value::Numeric,
    'big_decimal'       => SmartCore::Types::Value::BigDecimal,
    'boolean'           => SmartCore::Types::Value::Boolean,
    'array'             => SmartCore::Types::Value::Array,
    'hash'              => SmartCore::Types::Value::Hash,
    'proc'              => SmartCore::Types::Value::Proc,
    'class'             => SmartCore::Types::Value::Class,
    'module'            => SmartCore::Types::Value::Module,
    'tme'               => SmartCore::Types::Value::Time,
    'date_time'         => SmartCore::Types::Value::DateTime,
    'date'              => SmartCore::Types::Value::Date,
    'time_based'        => SmartCore::Types::Value::TimeBased
  }.freeze

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @rules = {}
    @lock = SmartCore::Engine::Lock.new
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
  alias_method :each_rule, :each

  private

  # @return [Hash<String,SmartCore::Schema::Checker::Rules::Base>]
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
