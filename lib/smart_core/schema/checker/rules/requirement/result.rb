# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Requirement::Result
  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  ERROR_CODE = :required_key_not_found

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :key

  # @return [SmartCore::Schema::Checker::VerifiableHash]
  #
  # @api private
  # @since 0.1.0
  attr_reader :verifiable_hash

  # @return [Symbol, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :error

  # @return [String, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :message

  # @param key [String]
  # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
  # @param required [Boolean]
  # @param key_exists [Boolean]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(key, verifiable_hash, required:, key_exists:)
    @key = key
    @verifiable_hash = verifiable_hash
    @required = required
    @optional = !required
    @key_exists = key_exists
    @success = required ? key_exists : true
    @failure = required ? !key_exists : false
    @error = required && !key_exists ? ERROR_CODE : nil
    @message = required && !key_exists ? 'required-ключа нет в схеме' : nil
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def success?
    @success
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def failure?
    @failure
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def key_exists?
    @key_exists
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def optional?
    @optional
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def required?
    @required
  end
end
