# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.8.0
class SmartCore::Schema::Checker::Reconciler
  require_relative 'reconciler/constructor'
  require_relative 'reconciler/matcher'

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.3.0
  def initialize
    @rules = SmartCore::Schema::Checker::Rules.new
    @strict = Constructor::DEFAULT_STRICT_BEHAVIOR
  end

  # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def __match!(verifiable_hash)
    SmartCore::Schema::Checker::Reconciler::Matcher.match(self, verifiable_hash)
  end

  # @return [SmartCore::Schema::Checker::Rules::ExtraKeys]
  #
  # @api private
  # @since 0.1.0
  def __extra_keys_contract
    SmartCore::Schema::Checker::Rules::ExtraKeys
  end

  # @return [SmartCore::Schema::Checker::Rules]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def __contract_rules
    rules
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.3.0
  # @version 0.8.0
  def __strict?
    @strict
  end

  # @param schema_key [String, Symbol]
  # @param nested_definitions [Block]
  # @return [SmartCore::Schema::Checker::Rules::Required]
  #
  # @api public
  # @since 0.1.0
  # @version 0.8.0
  def required(schema_key, &nested_definitions)
    rule = SmartCore::Schema::Checker::Rules::Required.new(self, schema_key, &nested_definitions)
    rule.tap { rules[rule.schema_key] = rule }
  end

  # @param schema_key [String, Symbol]
  # @param nested_definitions [Block]
  # @return [SmartCore::Schema::Checker::Rules::Optional]
  #
  # @api public
  # @since 0.1.0
  # @version 0.8.0
  def optional(schema_key, &nested_definitions)
    rule = SmartCore::Schema::Checker::Rules::Optional.new(self, schema_key, &nested_definitions)
    rule.tap { rules[rule.schema_key] = rule }
  end

  # @param is_strict [Boolean]
  # @return [void]
  #
  # @api public
  # @since 0.3.0
  # @version 0.8.0
  def strict!(is_strict = Constructor::DEFAULT_STRICT_BEHAVIOR)
    @strict = is_strict
  end

  # @return [void]
  #
  # @api public
  # @since 0.3.0
  # @version 0.8.0
  def non_strict!
    strict!(Constructor::STRICT_MODES[:non_strict])
  end

  private

  # @return [SmartCore::Schema::Checker::Rules]
  #
  # @api private
  # @since 0.1.0
  attr_reader :rules
end
