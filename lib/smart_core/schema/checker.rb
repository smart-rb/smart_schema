# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker
  require_relative 'checker/verifiable_hash'
  require_relative 'checker/rules'
  require_relative 'checker/reconciler'

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @reconciler = Reconciler::Constructor.create
    @lock = SmartCore::Engine::Lock.new
  end

  # @param verifiable_hash [Hash<String|Symbol,Any>]
  # @return [SmartCore::Schema::Result]
  #
  # @api private
  # @since 0.1.0
  def check!(verifiable_hash)
    thread_safe do
      raise(SmartCore::Schema::ArgumentError, <<~ERROR_MESSAGE) unless verifiable_hash.is_a?(Hash)
        Verifiable hash should be a type of ::Hash
      ERROR_MESSAGE

      reconciler.__match!(VerifiableHash.new(verifiable_hash)).complete!
    end
  end

  # @param definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def append_schema_definitions(&definitions)
    thread_safe { add_schema_definitions(&definitions) }
  end

  # @param another_checker [SmartCore::Schema::Checker]
  # @return [SmartCore::Schema::Checker]
  #
  # @api private
  # @since 0.1.0
  def combine_with(another_checker)
    thread_safe { self } # TODO (0.x.0): merge the definitions and return self
  end

  private

  # @return [SmartCore::Schema::Checker::Reconciler]
  #
  # @api private
  # @since 0.1.0
  attr_reader :reconciler

  # @param definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_schema_definitions(&definitions)
    raise(SmartCore::Schema::ArgumentError, <<~ERROR_MESSAGE) unless block_given?
      Schema definitions is not provided (you should provide Block argument)
    ERROR_MESSAGE

    Reconciler::Constructor.append_definitions(reconciler, &definitions)
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
