# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Base
  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :schema_key

  # @return [SmartCore::Schema::Checker::Rules::Options]
  #
  # @api private
  # @since 0.1.0
  attr_reader :options

  # @return [NilClass, SmartCore::Schema::Checker::Reconciler]
  #
  # @api private
  # @since 0.1.0
  attr_reader :nested_reconciler

  # @param schema_key [String, Symbol]
  # @param nested_definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(schema_key, &nested_definitions)
    # NOTE: technical options
    @schema_key = SmartCore::Schema::KeyControl.normalize(schema_key)
    @nested_reconciler = nil
    # NOTE: rule options
    @options = SmartCore::Schema::Checker::Rules::Options.new
    define_nested_reconciler(&nested_definitions)
  end

  # @param verifiable_value [Any]
  #
  # @api private
  # @since 0.1.0
  def __verify!(verifiable_value)
    SmartCore::Schema::Checker::Rules::Verifier.verify!(self, verifiable_value)
  end

  # @param required_type [String, Symbol, SmartCore::Types::Primitive]
  # @return [self]
  #
  # @api public
  # @since 0.1.0s
  def type(required_type)
    tap { options.type = SmartCore::Schema::Checker::Rules::Options::Type.new(required_type) }
  end

  private

  # @param nested_definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_nested_reconciler(&nested_definitions)
    return unless block_given?
    @nested_reconciler = SmartCore::Schema::Checker::Reconciler.create(nested_definitions)
  end
end
