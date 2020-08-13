# frozen_string_literal: true

module SmartCore::Schema::Checker::Rules::Result
  # @api private
  # @since 0.1.0
  class Failure < Base
    # @return [Symbol]
    #
    # @api public
    # @since 0.1.0
    attr_reader :error

    # @return [String]
    #
    # @api public
    # @since 0.1.0
    attr_reader :message

    # @option key [String]
    # @option value [Any]
    # @option error [Symbol]
    # @option message [String]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(key:, value:, error:, message:)
      super(key: key, value: value)
      @error = error
      @message = message
    end

    # @return [Boolean]
    #
    # @api public
    # @since 0.1.0
    def failure?
      true
    end
  end
end
