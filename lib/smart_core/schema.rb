# frozen_string_literal: true

require 'smart_core'

# @api pulic
# @since 0.1.0
module SmartCore
  # @api public
  # @since 0.1.0
  class Schema
    require_relative 'schema/version'
    require_relative 'schema/errors'
    require_relative 'schema/key_control'
    require_relative 'schema/checker'
    require_relative 'schema/dsl'

    # @since 0.1.0
    include SmartCore::Schema::DSL

    # @param schema [Hash]
    # @return [Boolean]
    #
    # @api public
    # @since 0.1.0
    def valid?(schema)
      validate!(schema)
      true
    rescue # => ???
      false
    end

    # @param schema [Hash]
    # @return [void]
    #
    # @raise [???]
    #
    # @api public
    # @since 0.1.0
    def validate!(schema); end
  end
end
