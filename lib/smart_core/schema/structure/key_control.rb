# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Structure::KeyControl
  class << self
    # @param key [String, Symbol]
    # @return [String]
    #
    # @api private
    # @since 0.1.0
    def normalize(key)
      key.to_s
    end
  end
end
