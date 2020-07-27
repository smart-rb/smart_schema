# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Checker::Result
  class Composite
    def initialize
      @results = { fail: [], succ: [] }
    end

    def <<(result)
      case result
      when PreSuccess
        @results[:succ] << result
      when PreFailure
        @results[:fail] << result
      when Composite
        # merge-peremerge
      end
    end

    def failure?
      @results[:fail].any?
    end

    def succ?
      !failre?
    end
  end

  class PreSuccess
    attr_reader :schema_key
    attr_reader :schema_value

    def initialize(schema_key, schema_value)
      @schema_key = schema_key
      @schema_value = schema_value
    end

    def failure?
      false
    end

    def success?
      true
    end
  end

  class PreFailure
    attr_reader :schema_key
    attr_reader :schema_value
    attr_reader :error_code

    def initialize(schema_key, schema_value, error_code)
      @schema_key = schema_key
      @schema_value = schema_value
      @error_code = error_code
    end

    def success?
      false
    end

    def failure?
      true
    end
  end
end
