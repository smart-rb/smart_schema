# frozen_string_literal: true

module SmartCore::Schema::Checker::Rules::ExtraKeys
  # @api private
  # @since 0.1.0
  # @version 0.3.0
  class Success < Result
    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def success?
      true
    end

    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def failure?
      false
    end
  end
end
