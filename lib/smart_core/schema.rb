# frozen_string_literal: true

require 'smart_core'
require 'smart_core/types'
require 'forwardable'

# @api pulic
# @since 0.1.0
module SmartCore
  # @api public
  # @since 0.1.0
  class Schema
    require_relative 'schema/version'
    require_relative 'schema/errors'
    require_relative 'schema/plugins'
    require_relative 'schema/type_system'
    require_relative 'schema/configuration'
    require_relative 'schema/key_control'
    require_relative 'schema/result'
    require_relative 'schema/checker'
    require_relative 'schema/dsl'

    # @since 0.1.0
    include SmartCore::Schema::DSL

    # @sicnce 0.12.0
    extend SmartCore::Schema::Plugins::AccessMixin

    class << self
      # NOTE/TODO: will be totally reworked with dynamic schema-instance-configurated type-system
      #
      # @api public
      # @since 0.12.0
      def type_system
        SmartCore::Schema::TypeSystem.resolve(SmartCore::Schema::Configuration[:type_system])
      end
    end

    # @param verifiable_hash [Hash<String|Symbol,Any>]
    # @return [Boolean]
    #
    # @api public
    # @since 0.1.0
    def valid?(verifiable_hash)
      validate(verifiable_hash).success?
    end

    # @param verifiable_hash [Hash<String|Symbol,Any>]
    # @return [SmartCore::Schema::Result]
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
