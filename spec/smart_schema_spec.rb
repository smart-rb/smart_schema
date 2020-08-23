# frozen_string_literal: true

RSpec.describe SmartCore::Schema do
  it 'has a version number' do
    expect(SmartCore::Schema::VERSION).not_to be nil
  end

  specify 'smoke' do
    class MySchema < SmartCore::Schema
      schema do
        required(:key) do
          optional(:data).type(:string) # .finalize { |val| } (0.2.0)
          optional(:value).type(:numeric)
          required(:name).type(:string) # .default('lol').finalize { |val| } (0.2.0)
          required(:age).type(:integer)
        end

        # @since 0.3.0
        # required(:another_key).schema(AnotherSchema)
      end

      schema do
        required(:b_key).type(:string)
      end

      # @since 0.2.0
      # validate('key.name') do
      # end

      # @since 0.2.0
      # default('key.data') do
      # end

      # @since 0.2.0
      # finalize('key.data') do |value|
      # end
    end

    result1 = MySchema.new.validate({})

    result2 = MySchema.new.validate({
      key: {
        data: 123,
        value: 123,
        name: 'vasia'
      }
    })

    binding.pry

    # binding.irb

    # =>
    # {
    #   'key.data' => error
    #   'key.data' => :missing
    #   'key.data' => :invalid_type
    # }
  end
end
