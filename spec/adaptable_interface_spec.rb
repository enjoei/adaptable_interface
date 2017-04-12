require 'spec_helper'
require 'support/not_adaptable_module'
require 'support/adaptable_module_with_adapters'

RSpec.describe AdaptableInterface do
  it 'has a version number' do
    expect(AdaptableInterface::VERSION).not_to be nil
  end

  describe '.camelize' do
    let(:term) { 'another_class' }

    context 'when string implements camelize' do
      before do
        allow_any_instance_of(String).to receive(:camelize).and_return('FORCE')
      end

      it 'uses the defined method' do
        expect(AdaptableInterface.camelize(term)).to eq 'FORCE'
      end
    end

    context 'when string has no camelize method' do
      it 'returns the string in class name format' do
        expect(AdaptableInterface.camelize(term)).to eq 'AnotherClass'
      end
    end
  end

  describe 'once included on adaptable object' do
    let(:null_adapter) do
      AdaptableModuleWithAdapters::Adapters::Null
    end

    let(:some_adapter) do
      AdaptableModuleWithAdapters::Adapters::SomeAdapter
    end

    subject(:adapted_object) do
      AdaptableModuleWithAdapters.include AdaptableInterface
    end

    it 'enables adaptable object to have a default adapter' do
      expect(adapted_object.adapter).to eq null_adapter
      expect(adapted_object).to be_using(:null)
    end

    it 'enables adaptable object to be configured' do
      adapted_object.adapter = :some_adapter
      expect(adapted_object.adapter).to eq some_adapter
      expect(adapted_object).to be_using(:some_adapter)
    end

    it 'raises error when trying to set an invalid adapter' do
      expect do
        adapted_object.adapter = :invalid
      end.to raise_error(AdaptableInterface::UndefinedAdapterClassError)
    end

    it 'enables us to retrieve an object for given adapter' do
      adapted_object.adapter = :some_adapter
      expect(adapted_object.new).to be_a(some_adapter)
    end
  end

  describe 'once included on not adaptable object' do
    subject(:adapted_object) do
      NotAdaptableModule.include AdaptableInterface
    end

    it 'raises an error when adding an adapter' do
      expect do
        adapted_object.adapter = :invalid
      end.to raise_error(AdaptableInterface::UndefinedAdapterClassError)
    end
  end
end
