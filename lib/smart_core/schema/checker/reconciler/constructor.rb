# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.2.0
module SmartCore::Schema::Checker::Reconciler::Constructor
  # @return [Hash<String,Boolean>]
  #
  # @api private
  # @since 0.2.0
  STRICT_MODES = { strict: true, 'strict' => true, non_strict: false, 'non_strict' => true }.freeze

  # @return [Boolean]
  #
  # @pai private
  # @since 0.2.0
  DEFAULT_STRICT_BEHAVIOR = STRICT_MODES[:strict] # NOTE: means `strict by default`

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

    # @param reconciler [SmartCore::Schema::Checker::Reconciler]
    # @param strict_mode [NilClass, String, Symbol]
    # @return [void]
    #
    # @api private
    # @since 0.2.0
    def set_strict_mode(reconciler, strict_mode)
      return if strict_mode == nil

      mode = STRICT_MODES.fetch(strict_mode) do
        raise(SmartCore::Schema::ArgumentError, <<~ERROR_MESSAGE)
          Unsupported schmea strict mode "#{strict_mode}".
          SmartCore::Schema supports "strict" and "non_strict" modes only.
        ERROR_MESSAGE
      end

      reconciler.strict!(mode)
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
