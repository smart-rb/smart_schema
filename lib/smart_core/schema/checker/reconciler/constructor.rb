# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Checker::Reconciler::Constructor
  class << self
    # @param reconciler [SmartCore::Schema::Checker::Reconciler]
    # @param definitions [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def append_definitions(reconciler, &definitions)
      reconciler.instance_eval(&definitions)
    end

    # @param definitions [Proc, NilClass]
    # @return [SmarCore::Schema::Checker::Reconciler]
    #
    # @api private
    # @since 0.1.0
    def create(&definitions)
      SmartCore::Schema::Checker::Reconciler.new.tap do |reconciler|
        append_definitions(reconciler, &definitions) if block_given?
      end
    end
  end
end
