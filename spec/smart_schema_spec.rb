# frozen_string_literal: true

RSpec.describe SmartCore::Schema do
  it 'has a version number' do
    expect(SmartCore::Schema::VERSION).not_to be nil
  end

  specify 'smoke' do
    class MySchema < SmartCore::Schema
      strict!

      schema(:non_strict) do
        strict!

        required(:key) do
          optional(:data).type(:string)
          optional(:value).type(:numeric)
          required(:name).type(:string)
          required(:age).type(:integer)
          required(:rizdos) do
            non_strict!

            required(:pui).type(SmartCore::Types::Value::String)
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

    # invalid schema
    result_1 = MySchema.new.validate({})

    expect(result_1.success?).to eq(false)
    expect(result_1.errors).to match(
      'key'   => [:required_key_not_found],
      'b_key' => [:required_key_not_found],
      'c_key' => [:required_key_not_found]
    )
    expect(result_1.extra_keys).to be_empty
    expect(result_1.spread_keys).to be_empty

    # invalid schema
    result_2 = MySchema.new.validate({
      key: {
        data: 123,
        value: 123,
        name: 'D@iVeR',
        rizdos: {
          pui: 123, 
          che: true, # spread-key (key from non-strict schema)
          cheburek: { 
            jaja: nil 
          },
          urban_strike: {} 
        },
        cheburek: {}, # extra-key (key from strict schema)
        urban_strike: {} # extra-key (key from strict schema)
      },
      c_key: { itmo: {} }
    })

    expect(result_2.success?).to eq(false)
    expect(result_2.errors).to match(
      'key.data' => [:invalid_type],
      'key.age' => [:required_key_not_found],
      'key.rizdos.pui' => [:invalid_type],
      'key.rizdos.cheburek.jaja' => [:non_filled],
      'b_key' => [:required_key_not_found],
      'c_key.itmo.gigabyte' => [:required_key_not_found],
      'key.cheburek' => [:extra_key],
      'key.urban_strike' => [:extra_key],
    )
    expect(result_2.extra_keys).to contain_exactly(
      'key.cheburek',
      'key.urban_strike'
    )
    # TODO: spread keys aggregation and check
    # expect(result_2.spread_keys).to contain_exactly(
    #   'key.rizdos.che'
    # )

    # valid state
    result_3 = MySchema.new.validate({
      key: {
        data: 'test',
        value: 123,
        name: 'D@iVeR',
        age: 28,
        rizdos: { pui: '123', cheburek: { jaja: 29.0 }, urban_strike: {} }
      },
      b_key: 'some_string',
      c_key: { itmo: { gigabyte: 21.1 } }
    })

    expect(result_3.success?).to eq(true)
    expect(result_3.errors).to eq({})
    expect(result_3.extra_keys).to be_empty

    expect(MySchema.new.valid?({})).to eq(false)
    expect(MySchema.new.valid?({
      key: {
        data: 'test',
        value: 123,
        name: 'D@iVeR',
        age: 28,
        rizdos: { pui: '123', cheburek: { jaja: 29.0 }, urban_strike: {} }
      },
      b_key: 'some_string',
      c_key: { itmo: { gigabyte: 21.1 } }
    })).to eq(true)

    expect do # incompatible dsl (schema)
      Class.new(SmartCore::Schema) { schema { non_required } }
    end.to raise_error(::NameError)

    expect do # incompatible type
      Class.new(SmartCore::Schema) { schema { required(:kek).type(Object.new) } }
    end.to raise_error(::SmartCore::Schema::ArgumentError)
  end
end
