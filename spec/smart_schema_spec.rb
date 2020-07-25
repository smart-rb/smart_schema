# frozen_string_literal: true

RSpec.describe SmartCore::Schema do
  it 'has a version number' do
    expect(SmartCore::Schema::VERSION).not_to be nil
  end

  specify 'smoke' do
    class MySchema < SmartCore::Schema
      schema do
        required(:key) do
          optional(:data).type(:string).finalize { |val| }
          optional(:value).type(:numeric)
          required(:name).type(:string).default('lol').finalize { |val| }
        end
      end

      validate('key.name') do
      end

      default('key.data') do
      end

      finalize('key.data') do |value|
      end
    end

    MySchema.new.valid?({

    })

    # =>
    # {
    #   'key.data' => error
    #   'key.data' => :missing
    #   'key.data' => :invalid_type
    # }
  end
end
