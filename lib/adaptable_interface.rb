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

  # Transforms strings into class name format.
  # If the given string respond to `camelize` we use the already defined
  # implementation, otherwise the gem has a internal basic implementation of it.
  #
  # @param [String, Symbol] the term to be camelized.
  # @return [String] a camelized version of the given term.
  # @example AdaptableInterface.camelize('another_class') returns AnotherClass.
  def self.camelize(term)
    string = term.to_s
    if string.respond_to?(:camelize)
      string.camelize
    else
      string = string.sub(/^[a-z\d]*/) { |match| match.capitalize }
      string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
      string.gsub!('/'.freeze, '::'.freeze)
      string
    end
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
        adapter_class = AdaptableInterface.camelize(adapter)
        begin
          @adapter = self::Adapters.const_get(adapter_class)
        rescue NameError
          raise UndefinedAdapterClassError.new(self, adapter_class)
        end
      else
        @adapter = nil
      end
    end

    # Verify if the adaptable object is using the given adapter.
    #
    # @param [Symbol] the adapter name to be tested
    # @return [Boolean]
    def using?(adapter_name)
      current_adapter_name = adapter.name.split('::').last
      expected_class_name = AdaptableInterface.camelize(adapter_name)

      current_adapter_name == expected_class_name
    end

    # Initializes the adaptable object based on current adapter configuration.
    # @return [Object] one object of the defined adapter type
    def new(*params)
      adapter.new(*params)
    end
  end
end
