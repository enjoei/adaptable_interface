module AdaptableInterface
  # Error to be raised in case of missing class inside Adapters module.
  class UndefinedAdapterClassError < NameError
    def initialize(klass, adapter_class)
      super("cannot find an adapter for #{adapter_class} on #{klass}::Adapters")
    end
  end
end
