# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::VerifiableHash
  # @return [Hash<String|Symbol,Any>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :source

  # @param source [Hash<String|Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(source)
    @source = source
    @lock = SmartCore::Engine::Lock.new
  end

  # @param key [String]
  # @return [SmartCore::Schema::Checker::VerifiableHash]
  #
  # @api private
  # @since 0.1.0
  def extract(key)
    @lock.synchronize { SmartCore::Schema::Checker::VerifiableHash.new(fetch(key)) }
  end

  # @return [Array<String>]
  #
  # @api private
  # @since 0.1.0
  def keys
    @lock.synchronize { SmartCore::Schema::KeyControl.normalize_list(source.keys) }
  end

  # @param key [String]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def key?(key)
    @lock.synchronize { source.key?(key) || source.key?(key.to_sym) }
  end

  # @param key [String]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def fetch(key)
    # rubocop:disable Style/RedundantBegin
    @lock.synchronize do
      begin
        source.fetch(key)
      rescue KeyError
        source.fetch(key.to_sym)
      end
    end
    # rubocop:enable Style/RedundantBegin
  end
  alias_method :[], :fetch
end
