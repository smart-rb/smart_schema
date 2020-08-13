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

  # @param verifiable_hash [Hash<String|Symbol,Any>]
  # @return [SmartCore::Schema::Checker::Rules::Verifier::Result]
  #
  # @api private
  # @since 0.1.0
  def __verify!(verifiable_hash)
    SmartCore::Schema::Checker::Rules::Verifier.verify!(self, verifiable_hash)
  end

  # @param required_type [String, Symbol, SmartCore::Types::Primitive]
  # @return [self]
  #
  # @api public
  # @since 0.1.0
  def type(required_type)
    tap do
      options.type = SmartCore::Schema::Checker::Rules::Options::Type.new(required_type)
    end
  end

  # @return [self]
  #
  # @api ublic
  # @since 0.1.0
  def filled
    tap do
      options.filled = SmartCore::Schema::Checker::Rules::Options::Filled.new
    end
  end

  private

  # @param nested_definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_nested_reconciler(&nested_definitions)
    @nested_reconciler = SmartCore::Schema::Checker::Reconciler::Constructor.create(
      &nested_definitions
    ) if block_given?
  end
end
