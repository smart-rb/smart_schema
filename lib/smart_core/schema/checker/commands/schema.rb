# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Checker::Commands
  class Schema < Base
    # @param definitions [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(definitions)
      @reconciler = SmartCore::Schema::Checker::Reconciler.create(definitions)
    end

    # @param hash_struct [Hash<String|Symbol,Any>]
    # @oaram schema [SmartCore::Schema]
    # @return [?]
    #
    # @api private
    # @since 0.1.0
    def call(hash_struct, schema)
    end

    private

    # @return [SmartCore::Schema::Checker::Reconciler]
    #
    # @api private
    # @since 0.1.0
    attr_reader :reconciler
  end
end
