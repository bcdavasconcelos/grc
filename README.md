# GRC - Methods for working with Ancient Greek in Ruby

[![Ruby](https://github.com/bcdavasconcelos/grc/actions/workflows/main.yml/badge.svg)](https://github.com/bcdavasconcelos/grc/actions/workflows/main.yml) [![Gem Version](https://badge.fury.io/rb/grc.svg)](https://badge.fury.io/rb/grc)
           
```ruby
'αβγ'.grc?                 # true
'abc'.grc?                 # false
'ἄ'.no_downcase_diacritics # α
'Ἀ'.no_upcase_diacritics   # Α
'ἄἈ'.no_diacritics         # αΑ
'ά'.tonos_to_oxia          # ά
'ά'.oxia_to_tonos          # ά
'ὰ'.grave_to_acute         # ά
'ά'.acute_to_grave         # ὰ
'α'.unicode_name           # ['GREEK SMALL LETTER ALPHA']
'α'.unicode_points         # ['\\u03B1']
'ᾄ'.nfc                    # ᾄ
'ᾄ'.nfd                    # ᾄ
```

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add grc

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install grc

## Usage


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/grc. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/grc/blob/Main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Grc project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/grc/blob/Main/CODE_OF_CONDUCT.md).
