# frozen_string_literal: true

# rubocop:disable Naming/VariableNumber
RSpec.describe SmartCore::Schema do
  it 'has a version number' do
    expect(SmartCore::Schema::VERSION).not_to be nil
  end

  specify 'test dry-types' do
    SmartCore::Schema::Configuration.configure { |conf| conf.type_system = :dry_types }
    SmartCore::Schema.type_system.type_alias(:integer, Dry::Types['integer'])

    class DryTypesTestingSchema < SmartCore::Schema
      schema do
        required(:date).type(Dry::Types['string']) # object-style
        required(:memo).type(:integer) # aliase-style
      end
    end

    expect do
      Class.new(SmartCore::Schema) do
        schema do
          # NOTE: should not fail on nested schemas
          required(:pek) do
            required(:kek).type(Dry::Types['integer'])
          end
        end
      end
    end.not_to raise_error

    class PrimitiveNestedSchema < SmartCore::Schema
      schema do
        required(:nested) do
          required(:field).type(:integer)
        end
      end
    end

    nested_schema = PrimitiveNestedSchema.new
    expect(nested_schema.valid?({ nested: { field: 123 } })).to eq(true)
    expect(nested_schema.valid?({ nested: { field: '123' } })).to eq(false)

    # TODO:
    #  - uncomment followwing spec
    #  - need to fix nested schema structure reocniling bug (fails on source.key?(key) code)
    # expect(nested_schema.valid?({ nested: 123 })).to eq(false)
    # expect(nested_schema.valid?({ nested: {} })).to eq(false)

    expect do
      Class.new(SmartCore::Schema) do
        schema do
          required(:mega).type(Object) # FAIL: dry-types requires Dry::Types::Type objects!
        end
      end
    end.to raise_error(SmartCore::Schema::ArgumentError)

    # expect do
      # class SomeFailableSchema < SmartCore::Schema
      #   schema do
      #     requried(:pek).type(:kek)
      #   end
      # end
    # end

    result_1 = DryTypesTestingSchema.new.validate({ date: 123, memo: '123' })
    expect(result_1.success?).to eq(false)
    expect(result_1.errors).to match(
      'date' => [:invalid_type],
      'memo' => [:invalid_type]
    )

    result_2 = DryTypesTestingSchema.new.validate({})
    expect(result_2.success?).to eq(false)
    expect(result_2.errors).to match(
      'date' => [:required_key_not_found],
      'memo' => [:required_key_not_found]
    )

    result_3 = DryTypesTestingSchema.new.validate({ date: '123' })
    expect(result_3.success?).to eq(false)
    expect(result_3.errors).to match('memo' => [:required_key_not_found])

    result_4 = DryTypesTestingSchema.new.validate({ memo: 123 })
    expect(result_4.success?).to eq(false)
    expect(result_4.errors).to match('date' => [:required_key_not_found])

    result_5 = DryTypesTestingSchema.new.validate({ date: '123', memo: 123 })
    expect(result_5.success?).to eq(true)
  end

  specify 'smoke' do
    SmartCore::Schema::Configuration.configure do |conf|
      conf.type_system = :smart_types
    end

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
      'key.urban_strike' => [:extra_key]
    )
    expect(result_2.extra_keys).to contain_exactly(
      'key.cheburek',
      'key.urban_strike'
    )
    # TODO: spread keys aggregation and check
    # expect(result_2.spread_keys).to contain_exactly(
    #   'key.rizdos.che'
    # )
    expect(result_2.spread_keys).to be_empty

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
    expect(result_3.spread_keys).to be_empty

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

    class StrictByDefaultSchema < SmartCore::Schema
      schema do
        required(:jaga).type(:string)
      end
    end

    result_4 = StrictByDefaultSchema.new.validate({ jaga: 'test', gaga: 123 })
    expect(result_4.success?).to eq(false)
    expect(result_4.failure?).to eq(true)
    expect(result_4.extra_keys).to contain_exactly('gaga')
    expect(result_4.spread_keys).to be_empty

    class InheritableModeSchema < SmartCore::Schema
      schema(:non_strict) do # non-strict
        required(:kek) do # non-strict (inherited)
          required(:pek) do # non-strict (inherited)
            optional(:buba)
          end

          required(:jek) do # strict (manually defined)
            strict!
            optional(:biba)
          end
        end
      end
    end

    result_5 = InheritableModeSchema.new.validate({
      kek: {
        gek: 1,
        pek: {
          check: 2, buba: 3
        },
        jek: {
          aza: 2
        }
      },
      fek: 5
    })
    expect(result_5.success?).to eq(false)
    expect(result_5.failure?).to eq(true)
    expect(result_5.extra_keys).to contain_exactly('kek.jek.aza')

    class InitialNonStrictSchema < SmartCore::Schema
      non_strict!

      schema do
        required(:pek)
      end
    end

    result_6 = InitialNonStrictSchema.new.validate({ pek: 1, kek: 2 })
    expect(result_6.success?).to eq(true)
    expect(result_6.failure?).to eq(false)
    expect(result_6.extra_keys).to be_empty
    expect(result_6.spread_keys).to be_empty

    expect do # incompatible dsl (schema)
      Class.new(SmartCore::Schema) { schema { non_required } }
    end.to raise_error(NameError)

    expect do # incompatible type
      Class.new(SmartCore::Schema) { schema { required(:kek).type(Object.new) } }
    end.to raise_error(SmartCore::Schema::ArgumentError)
  end
end
# rubocop:enable Naming/VariableNumber
