# Rescue From

An imitation of `ActiveSupport::Rescuable` that relies on Ruby's callbacks to reduce boilerplate code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rescue_from', '~> 2.0'
```

And then execute:

```bash
$ bundle
```

Or you can install the gem on its own:

```bash
gem install rescue_from
```

## Usage

Simply extend with `RescueFrom::Rescuable` any class or module that you want to use `rescue_from` in.

```ruby
class DataImporter
  extend RescueFrom::Rescuable

  rescue_from JSON::ParserError do
    []
  end

  def temperature_data
    JSON.parse File.read('temperatures.json')
  end

  def humidity_data
    JSON.parse File.read('humidity.json')
  end
end
```

Both `#temperature_data` and `#humidity_data` will return an empty array if the respective files contain JSON syntax errors.

`rescue_from` can accept multiple patterns, and will associate the same handler with all of them. Handlers are looked up top to bottom, left to right, and up the ancestors chain as it is returned by `self.class.ancestors`. The lookup uses case equality to match patterns against the raised exception, so you can use less straightforward patterns instead of classes. This class will silence all exceptions the messages of which don't start with "failure":

```ruby
class Service
  extend RescueFrom::Rescuable

  rescue_from(proc {|e| !e.message.start_with? 'failure'}) do
    nil
  end

  ...
end
```

If no pattern matches the exception, it will be reraised.

Handlers are called in the context of the receiver of the method that raised the exception.

If you want to call a given method bypassing the automatic exception handling, you can append `_without_rescue` to its name:

```ruby
di = DataImporter.new
di.temperature_data # => []
di.temperature_data_without_rescue # => JSON::ParserError
```

Sometimes, instead of silencing the exception, you want to change its class, for example if you're using the same low level library in different parts of the application and you need to distinguish the exceptions coming from the different sides. In such cases, you can use `relabel`:

```ruby
class Service
  extend RescueFrom::Rescuable

  relabel pattern1, pattern2, ..., to: ExceptionClass do |e|
    code
  end

  ...
end
```

is equivalent to

```ruby
class Service
  extend RescueFrom::Rescuable

  rescue_from pattern1, pattern2, ... do |e|
    message = code
    raise ExceptionClass, message
  end

  ...
end
```

If you want to limit automatic exception handling to only certain methods, you can override `should_rescue_in?`. It will be called every time a new method is defined, receiving its name as single argument; if it returns `false` or `nil`, the method is left untouched.

```ruby

class Service
  extend RescueFrom::Rescuable

  ACTIONS = [:create, :update, :delete]

  def self.should_rescue_in? method_name
    ACTIONS.include? method_name
  end

  ...
end
```

## Version numbers

Rescue From loosely follows [Semantic Versioning](https://semver.org/), with a hard guarantee that breaking changes to the public API will always coincide with an increase to the `MAJOR` number.

Version numbers are in three parts: `MAJOR.MINOR.PATCH`.

- Breaking changes to the public API increment the `MAJOR`. There may also be changes that would otherwise increase the `MINOR` or the `PATCH`.
- Additions, deprecations, and "big" non breaking changes to the public API increment the `MINOR`. There may also be changes that would otherwise increase the `PATCH`.
- Bug fixes and "small" non breaking changes to the public API increment the `PATCH`.

Notice that any feature deprecated by a minor release can be expected to be removed by the next major release.

## Changelog

Full list of changes in [CHANGELOG.md](CHANGELOG.md)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moku-io/rescue_from.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
