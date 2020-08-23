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
    @lock = SmartCore::Engine::Lock.new
    @schema_key = SmartCore::Schema::KeyControl.normalize(schema_key)
    @options = SmartCore::Schema::Checker::Rules::Options.new(self)
    @nested_reconciler = nil
    define_nested_reconciler(&nested_definitions)
  end

  # @!method requirement
  #   @return [SmartCore::Schema::Checker::Rules::Requirement::Optional]
  #   @return [SmartCore::Schema::Checker::Rules::Requirement::Required]

  # @param verifiable_hash [Hash<String|Symbol,Any>]
  # @return [SmartCore::Schema::Checker::Rules::Verifier::Result]
  #
  # @api private
  # @since 0.1.0
  def __verify!(verifiable_hash)
    SmartCore::Schema::Checker::Rules::Verifier.verify!(self, verifiable_hash)
  end

  # @param required_type [String, Symbol, SmartCore::Types::Primitive]
  # @param nested_definitions [Block]
  # @return [self]
  #
  # @api public
  # @since 0.1.0
  def type(required_type, &nested_definitions)
    thread_safe do
      tap do
        options.type = SmartCore::Schema::Checker::Rules::Options::Type.new(self, required_type)
        define_nested_reconciler(&nested_definitions)
      end
    end
  end

  # @param nested_definitions [Block]
  # @return [self]
  #
  # @api ublic
  # @since 0.1.0
  def filled(&nested_definitions)
    thread_safe do
      tap do
        options.filled = SmartCore::Schema::Checker::Rules::Options::Filled.new(self)
        define_nested_reconciler(&nested_definitions)
      end
    end
  end

  private

  # @param nested_definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_nested_reconciler(&nested_definitions)
    return unless block_given?

    SmartCore::Schema::Checker::Reconciler::Constructor.tap do |constructor|
      @nested_reconciler = constructor.create if @nested_reconciler.nil?
      constructor.append_definitions(@nested_reconciler, &nested_definitions)
    end

    type(:hash).filled
  end

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
