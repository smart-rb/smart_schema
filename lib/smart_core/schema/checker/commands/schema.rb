# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Checker::Commands
  class Schema < Base
    # @return [Proc]
    #
    # @api private
    # @since 0.1.0
    attr_reader :definitions

    # @param definitions [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(definitions)
      @definitions = definitions
    end
  end
end
