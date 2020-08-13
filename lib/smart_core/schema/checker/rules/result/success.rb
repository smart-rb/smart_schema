# frozen_string_literal: true

module SmartCore::Schema::Checker::Rules::Result
  # @api private
  # @since 0.1.0
  class Success < Base
    # @return [Boolean]
    #
    # @api public
    # @since 0.1.0
    def success?
      true
    end
  end
end
