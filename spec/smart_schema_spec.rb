# frozen_string_literal: true

RSpec.describe SmartCore::Schema do
  it 'has a version number' do
    expect(SmartCore::Schema::VERSION).not_to be nil
  end

  specify 'smoke' do
    class MySchema < SmartCore::Schema
      schema do
        required(:key) do
          optional(:data).type(:string)
          optional(:value).type(:numeric)
          required(:name).type(:string)
          required(:age).type(:integer)
          required(:rizdos) do
            required(:pui).type(:string)
            required(:cheburek) do
              required(:jaja).filled
            end
            required(:urban_strike).type(:hash).filled
          end
        end

        # @since 0.2.0
        # inheritance!

        # @since 0.3.0
        # required(:another_key).schema(AnotherSchema)
        # compose_with(ThirdSchema)

        # @since 0.4.0
        # error_messages :thinking:
      end

      schema do
        required(:b_key).type(:string)

        required(:c_key) do
          required(:itmo) do
            required(:gigabyte).filled
          end.type(:hash).filled
        end
      end
    end

    result1 = MySchema.new.validate({})

    result2 = MySchema.new.validate({
      key: {
        data: 123,
        value: 123,
        name: 'vasia',
        rizdos: { pui: 123, che: true, cheburek: { jaja: nil }, urban_strike: {} },
        cheburek: {},
        urban_strike: {}
      },
      c_key: { itmo: {} }
    })

    binding.pry
  end
end
