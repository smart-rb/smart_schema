# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.7.0
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
  # @version 0.7.0
  def fetch(key)
    # rubocop:disable Style/RedundantBegin
    @lock.synchronize do
      # @note
      #   Previously we used exceptional flow "hash.fetch(key) rescue hash.fetch(key.to_sym)".
      #   This flow can generate a lot of useless objects during rescuable `KeyError` exception
      #   (useless error messages, backtraces, etc, object that was silently suppressed).
      #   So, the "if"-#key?-oriented flow is better (generates fewer number of objects statistically).
      source.key?(key) ? source.fetch(key) : source.fetch(key.to_sym)
    end
    # rubocop:enable Style/RedundantBegin
  end
  alias_method :[], :fetch
end
