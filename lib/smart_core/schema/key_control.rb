# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::KeyControl
  class << self
    # @param key [String, Symbol]
    # @return [String]
    #
    # @api private
    # @since 0.1.0
    def normalize(key)
      prevent_incompatible!(key)
      key.to_s
    end

    # @param keys [Array<String,Symbol>]
    # @return [Array<String>]
    #
    # @api private
    # @since 0.1.0
    def normalize_list(keys)
      keys.map { |key| normalize(key) }
    end

    # @param key [String, Symbol]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_incompatible!(key)
      unless key.is_a?(String) || key.is_a?(Symbol)
        raise(SmartCore::Schema::ArgumentError, <<~ERROR_MESSAGE)
          Schema keys should be a type of string or symbol
        ERROR_MESSAGE
      end
    end
  end
end
