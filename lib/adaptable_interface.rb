require 'adaptable_interface/version'
require 'adaptable_interface/undefined_adapter_class_error'

# Adaptable interface allows us to easily adapt modules in which it's included.
#
# The top level module should implement it's adapters inside Adapters module and
# each adapter should has its specific class.
module AdaptableInterface
  def self.included(klass)
    klass.extend ClassMethods
  end

  # Methods to be included on class level
  module ClassMethods
    # Returns the current adapter. By default it assumes :null.
    # @return [Class]
    def adapter
      return @adapter if @adapter
      self.adapter = :null
      @adapter
    end

    # Configures a new adapter class to module.
    #
    # @example Configuring service to use Service::Adapters::MockProvider
    #   Service.adapter = :mock_provider
    #
    # @raises [UndefinedAdapterClassError] if no adapter class can be found
    #   inside top level object Adapters module
    def adapter=(adapter)
      if adapter
        adapter_class = adapter.to_s.capitalize
        begin
          @adapter = self::Adapters.const_get(adapter_class)
        rescue NameError
          raise UndefinedAdapterClassError.new(self, adapter_class)
        end
      else
        @adapter = nil
      end
    end

    # Initializes the adaptable object based on current adapter configuration.
    # @return [Object] one object of the defined adapter type
    def new(*params)
      adapter.new(*params)
    end
  end
end
