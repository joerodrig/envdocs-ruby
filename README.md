# Envdocs
Simple and Lightweight Gem to handle Environment(ENV) variable sanity-checks and documentation. Providing teams with the ability to sanity-check their expected loaded ENV variables at any point.

Every team documents, stores and persists ENV variables differently. One of the most draining experiences for a team is forgetting to update an ENV key for an environment, pushing things through, and trying to understand why things aren't working. This gem aims to fix that.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'envdocs'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install envdocs
```

## Usage

1. Create a `sample_keys.yml` file in your application's `config` directory:
Example:
```yaml
- development:
  - key: RAILS_ENV
    description: Provides info on the rails env
    required: true
- key: FOO
    description: Testing
    required: false
- test:
  - key: RAILS_ENV
    description: Provides info on the rails env
    required: true
```
The top-level key denotes the environment name we'd like to check against(ie. development, test, etc...). The nested objects each represent a key we'd like to validate for that environment.

2. Initialize the gem by pointing it to your `sample_keys.yml` file in your application's `./config` folder.
```ruby
# initializers/envdocs.rb
Envdocs.configure(
  filename: 'sample_keys.yml',
  environment: Rails.env,
  opts: { include_optional: false }
)
```

3. Anywhere in your code that you'd like to validate the proper keys exist, call:
```ruby
Envdocs.find_missing_keys
```

When called, an array of strings will be returned containing any missing keys. If no keys are missing, an empty array will be returned.

## Contributing
Features, bug fixes and other changes to envdocs-ruby are gladly accepted. Please open issues or a pull request with your change.

## License
The gem is available as open source under the terms of the [LGPLv3 License](https://www.gnu.org/licenses/lgpl-3.0.html).
