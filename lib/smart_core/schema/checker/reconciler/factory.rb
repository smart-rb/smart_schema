# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Checker::Reconciler::Factory
  class << self
    # @param definitions [Proc, NilClass]
    # @return [SmarCore::Schema::Checker::Reconciler]
    #
    # @api private
    # @since 0.1.0
    def create(definitions)
      SmartCore::Schema::Checker::Reconciler.new.tap do |reconciler|
        reconciler.instance_eval(&definitions)
        # если при конструировании реконсайлера евалом дефинишнов будут вылетать эксепшны вида
        # NoMethodError саомго реконсайлера (из-за отсутствуюещго левого метода вызываемого
        # евалом на инстансе реконсайлера) - перехватывать как schema definition error-эксепшн
      end
    end
  end
end
