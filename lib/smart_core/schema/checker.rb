# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker
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
  # @return [?]
  #
  # @api private
  # @since 0.1.0
  def check!(verifiable_hash)
    thread_safe { reconciler.__match!(verifiable_hash) }
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
    thread_safe { self } # TODO: merge definitions and return self
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
