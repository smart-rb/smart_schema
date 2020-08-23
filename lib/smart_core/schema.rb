# frozen_string_literal: true

require 'smart_core'
require 'smart_core/types'
require 'set'

# @api pulic
# @since 0.1.0
module SmartCore
  # @api public
  # @since 0.1.0
  class Schema
    require_relative 'schema/version'
    require_relative 'schema/errors'
    require_relative 'schema/key_control'
    require_relative 'schema/result'
    require_relative 'schema/checker'
    require_relative 'schema/dsl'

    # @since 0.1.0
    include SmartCore::Schema::DSL

    # @param verifiable_hash [Hash<String|Symbol,Any>]
    # @return [Boolean]
    #
    # @api public
    # @since 0.1.0
    def valid?(verifiable_hash)
      validate(verifiable_hash).success? ? true : false
    end

    # @param verifiable_hash [Hash<String|Symbol,Any>]
    # @raise [?]
    #
    # @api public
    # @since 0.1.0
    def validate(verifiable_hash)
      schema_checker.check!(verifiable_hash)
    end

    private

    # @return [SmartCore::Schema::Checker]
    #
    # @api private
    # @since 0.1.0
    def schema_checker
      self.class.__schema_checker__
    end
  end
end
