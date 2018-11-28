# SC::Billing
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'sc-billing'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install sc-billing
```

## Create migration
```bash
make bash
cd spec/dummy
rails g migration name_of_your_migration
```
Then edit your migration there and copy it to the gem `db/migrations/` and to the project `db/migrations` folders.

## TODO

* fill README
* add rake tasks(sync subscriptions)
* add cancel subscription action
* add payment source actions(pure classes to call ?)
* add hooks on all operations and add tests
* update stripe-ruby-mock version

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
