# frozen_string_literal: true

module SmartCore::Schema::Checker::Rules::ExtraKeys
  # @api private
  # @since 0.1.0
  # @version 0.3.0
  class Failure < Result
    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def success?
      false
    end

    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def failure?
      true
    end
  end
end
