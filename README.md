# AdaptableInterface

A commom implementation for an adaptable interface for our services.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'adaptable_interface', git: 'https://github.com/enjoei/adaptable_interface.git'
```

And then execute:

    $ bundle

## Usage

The AdaptableInterface gem enables us to implement adaptable services with a simple include:

```ruby
module InstallmentCalculator
  module Adapters
    class Null
      def initialize(price, discount); end
    end
    class Moip
      def initialize(price, discount); end
    end
  end

  include AdaptableInterface
end
```

The original module should implement adapters inside a `Adapters` module. Each adapter implementation should be specific class.


We can set an adapter directly on base module:

```ruby
InstallmentCalculator.adapter = :moip
InstallmentCalculator.adapter = :null
```

If the specified adapter cannot be found it will raise an error:

```ruby
InstallmentCalculator.adapter = :test
AdaptableInterface::UndefinedAdapterClassError: cannot find an adapter for Test on InstallmentCalculator::Adapters
```

Notice that the adapter name is related to the classes declarated inside `Adapters` module.

Finally, an adaptable module can be initialized based on a adapter interface:

```ruby
InstallmentCalculator.adapter = :moip
calculator = InstallmentCalculator.new(100, true)
# => #<InstallmentCalculator::Adapters::Moip:0x007fdaa3182e70>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Pushing a new version to Gemfury

This gem is hosted on a private Gemfury server, so, once a new version is created we need to send it to our gemfury account.

In order to do this you need to run the following commands on project shell:

```
git remote add fury https://enjoei-admin@git.fury.io/enjoei/adaptable_interface.git
git push fury master
```

The second command will ask you a password. Get it with your project leader.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/enjoei/adaptable_interface. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

