# frozen_string_literal: true

# @api private
# @since 0.3.0
class SmartCore::Schema::Checker::Reconciler::Matcher::Options
  class << self
    # @param reconciler [SmartCore::Schema::Checker::Reconciler]
    # @return [SmartCore::Schema::Checker::Reconciler::Matcher::Options]
    #
    # @api private
    # @since 0.3.0
    def build_from(reconciler)
      new(reconciler.__strict?)
    end
  end

  # @param is_strict_schema [Boolean]
  # @return [void]
  #
  # @api private
  # @since 0.3.0
  def initialize(is_strict_schema)
    @is_strict_schema = is_strict_schema
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.3.0
  def strict_schema?
    @is_strict_schema
  end
end
