require 'spec_helper'
require 'support/not_adaptable_module'
require 'support/adaptable_module_with_adapters'

RSpec.describe AdaptableInterface do
  it 'has a version number' do
    expect(AdaptableInterface::VERSION).not_to be nil
  end

  describe 'once included on adaptable object' do
    let(:null_adapter) do
      AdaptableModuleWithAdapters::Adapters::Null
    end

    let(:another_adapter) do
      AdaptableModuleWithAdapters::Adapters::Another
    end

    subject(:adapted_object) do
      AdaptableModuleWithAdapters.include AdaptableInterface
    end

    it 'enables adaptable object to have a default adapter' do
      expect(adapted_object.adapter).to eq null_adapter
    end

    it 'enables adaptable object to be configured' do
      adapted_object.adapter = :another
      expect(adapted_object.adapter).to eq another_adapter

      adapted_object.adapter = :null
      expect(adapted_object.adapter).to eq null_adapter
    end

    it 'raises error when trying to set an invalid adapter' do
      expect do
        adapted_object.adapter = :invalid
      end.to raise_error(AdaptableInterface::UndefinedAdapterClassError)
    end

    it 'enables us to retrieve an object for given adapter' do
      adapted_object.adapter = :another
      expect(adapted_object.new).to be_a(another_adapter)
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
