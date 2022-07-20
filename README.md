# GRC - Ancient Greek Methods for Ruby
 
Several problems can come up when using unicode greek characters. This gem solves some of them.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add grc

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install grc

## Usage 

```ruby
require 'grc'
```

## General methods

### `grc?` (str → bool)

String contains greek letters? This method will check and return `true` or `false`.

```ruby
irb(main):001:0> 'Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος'.grc?
=> true

irb(main):002:0> 'Greekless sentence'.grc?
=> false
```

### `tokenize` (str → array)

This method will tokenize a string; i.e., return an array of objects such as words and punctuation marks.

```ruby
irb(main):003:0> 'Πάντες ἄνθρωποι τοῦ εἰδέναι ὀρέγονται φύσει. σημεῖον δ᾽ ἡ τῶν αἰσθήσεων ἀγάπησις· καὶ γὰρ χωρὶς τῆς χρείας ἀγαπῶνται δι᾽ αὑτάς, καὶ μάλιστα τῶν ἄλλων ἡ διὰ τῶν ὀμμάτων.'.tokenize
=> ["Πάντες", "ἄνθρωποι", "τοῦ", "εἰδέναι", "ὀρέγονται", "φύσει", ".", "σημεῖον", "δ᾽", "ἡ",
   "τῶν", "αἰσθήσεων", "ἀγάπησις", "·", "καὶ", "γὰρ", "χωρὶς", "τῆς", "χρείας", "ἀγαπῶνται",
   "δι᾽", "αὑτάς", ",", "καὶ", "μάλιστα", "τῶν", "ἄλλων", "ἡ", "διὰ", "τῶν", "ὀμμάτων", "."]

irb(main):004:0> 'Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος'.tokenize
=> ["Μῆνιν", "ἄειδε", "θεὰ", "Πηληϊάδεω", "Ἀχιλῆος"]
```

### `transliterate` (str → str)

This is highly experimental method to transliterate greek into latin letters. Users are likely to encounter bugs and edge-cases. Please, report them.

```ruby
irb(main):005:0> 'Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος'.transliterate
=> "mēnin aeide thea pēlēiadeō achilēos"

irb(main):006:0> 'Πάντες ἄνθρωποι τοῦ εἰδέναι ὀρέγονται φύσει'.transliterate
=> "pantes anthrōpoi tou eidenai oregontai physei"
```

## Unicode Inspection Methods

### `unicode_points` (str → array)

This method will return an array with unicode points (the Unicode mapping) of every character in the string.

```ruby
irb(main):008:0> 'θεὰ'.unicode_points
=> ["\\u03B8", "\\u03B5", "\\u1F70"]
```

### `hash_dump`: (str → hash)

Same as `unicode_points`, but returns a hash. Still experimental.

```ruby
irb(main):009:0> str.hash_dump
=> {"ἄ"=>"\"\\u1F04\"", "ε"=>"\"\\u03B5\"", "ι"=>"\"\\u03B9\"", "δ"=>"\"\\u03B4\""}
```

### `unicode_name` (str → array)

This method will return an array with the unicode name of each character in the string.

```ruby
irb(main):010:0> 'θεὰ'.unicode_name
=> ["GREEK SMALL LETTER THETA", "GREEK SMALL LETTER EPSILON", "GREEK SMALL LETTER ALPHA WITH VARIA"]
```

## Unicode Normalization

Unicode Normalization is exceptionally important for Greek texts. It is used to normalize the text to a standard form, which is used by the computer to compare texts and for performing searches in a database.

### `nfd`: Canonical Decomposition (str → str)

This methods will decompose a string into its parts using the canonical decomposition method. This is useful for preparing a string to be used in searches. It will never damage the text by performing irreparable changes: a string can be recomposed using the canonical composition at any time.

This is our test string. Pay attention to the first character.

```ruby
irb(main):011:0> str = 'ἄνθρωπος'
=> "ἄνθρωπος"
irb(main):012:0> str.unicode_name
=>
  ["GREEK SMALL LETTER ALPHA WITH PSILI AND OXIA",
   "GREEK SMALL LETTER NU",
   "GREEK SMALL LETTER THETA",
   "GREEK SMALL LETTER RHO",
   "GREEK SMALL LETTER OMEGA",
   "GREEK SMALL LETTER PI",
   "GREEK SMALL LETTER OMICRON",
   "GREEK SMALL LETTER FINAL SIGMA"]
```

Now, we decomposed the precomposed unicode characters. 

```ruby
irb(main):013:0> str = str.nfd
=> "ἄνθρωπος"
irb(main):014:0> str.unicode_name
=>
  ["GREEK SMALL LETTER ALPHA",
   "COMBINING COMMA ABOVE",
   "COMBINING ACUTE ACCENT",
   "GREEK SMALL LETTER NU",
   "GREEK SMALL LETTER THETA",
   "GREEK SMALL LETTER RHO",
   "GREEK SMALL LETTER OMEGA",
   "GREEK SMALL LETTER PI",
   "GREEK SMALL LETTER OMICRON",
   "GREEK SMALL LETTER FINAL SIGMA"]
```

Notice how `ἄ` (`GREEK SMALL LETTER ALPHA WITH PSILI AND OXIA`) becomes `α` (`GREEK SMALL LETTER ALPHA`), `̓` (`COMBINING COMMA ABOVE`), `́` (`COMBINING ACUTE ACCENT`). If we decompose a string and then try to match a query against it, there will be no need to get the diacritics right and we'll only need the base-character.

Let us try to match the query `ανθρω` against the string in different versions.

str_nfc = str.nfc
str_nfd = str.nfd

```ruby
irb(main):015:0> str_nfc.match('ανθρω')
=> #<MatchData "ανθρω" "ανθρω">
irb(main):016:0> str_nfd.match('ανθρω')
=> #<MatchData "ανθρω" "ανθρω">
irb(main):017:0> str_nfc.match('ανθρω')
=> #<MatchData "ανθρω" "ανθρω">
irb(main):018:0> str_nfd.match('ανθρω')
=> #<MatchData "ανθρω" "ανθρω">
irb(main):019:0> str_nfc.match('ανθρω')
=> #<MatchData "ανθρω" "ανθρω">
irb(main):020:0> str_nfd.match('ανθρω')
=> #<MatchData "ανθρω" "ανθρω">
irb(main):021:0> str_nfc.match('ανθρω')
=> #<MatchData "ανθρω" "ανθρω">
  
irb(main):015:0> str.match('ανθρω')
=> #<MatchData "ανθρω" 1:"ανθρω">
irb(main):016:0> str.match('ανθρω').to_s
=> "ανθρω"
irb(main):017:0> str.match('ανθρω').to_s.nfd
=> "ανθρω"
irb(main):018:0> str.match('ανθρω').to_s.nfd.unicode_name
=> ["GREEK SMALL LETTER ALPHA", "GREEK SMALL LETTER NU", "GREEK SMALL LETTER THETA", "GREEK SMALL LETTER RHO", "GREEK SMALL LETTER OMEGA", "GREEK SMALL LETTER PI", "GREEK SMALL LETTER OMICRON", "GREEK SMALL LETTER FINAL SIGMA"]
```

irb(main):015:0> str.match('ἄνθρωπος')
=> #<MatchData "ἄνθρωπος">
irb(main):016:0> str.match('ἄνθρωπος').to_s
=> "ἄνθρωπος"
irb(main):017:0> str.match('ἄνθρωπος').to_s.nfd
=> "ἄνθρωπος"
irb(main):018:0> str.match('ἄνθρωπος').to_s.nfd.match('ἄνθρωπος')
=> #<MatchData "ἄνθρωπος">
irb(main):019:0> str.match('ἄνθρωπος').to_s.nfd.match('ἄνθρωπος').to_s
=> "ἄνθρωπος"
```

### `nfc` (str → str)

Using the result string from the last example, we can compose the characters back into its precomposed form. `α` (alpha), `̓` (smooth breathing), `́` (acute accent) will be composed back into a single character, that is, `ἄ` (alpha with breathing and acute accent).

```ruby
irb(main):015:0> str = str.nfc
=> "ἄνθρωπος"
irb(main):016:0> str.unicode_name
=>
  ["GREEK SMALL LETTER ALPHA WITH PSILI AND OXIA",
   "GREEK SMALL LETTER NU",
   "GREEK SMALL LETTER THETA",
   "GREEK SMALL LETTER RHO",
   "GREEK SMALL LETTER OMEGA",
   "GREEK SMALL LETTER PI",
   "GREEK SMALL LETTER OMICRON",
   "GREEK SMALL LETTER FINAL SIGMA"]
```

## Diacritical marks

This is our example string for the next 3 methods.

```ruby
irb(main):017:0> str = 'Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος'
=> "Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος"
```

### `no_downcase_diacritics` (str → str)

Remove from lowercase characters.

```ruby
irb(main):018:0> str.no_downcase_diacritics
=> "Μηνιν αειδε θεα Πηληιαδεω Ἀχιληος"
```

### `no_upcase_diacritics` (str → str)

Remove from uppercase characters.

```ruby
irb(main):019:0> str.no_upcase_diacritics
=> "Μῆνιν ἄειδε θεὰ Πηληϊάδεω Αχιλῆος"
```

### `no_diacritics` (str → str)

Remove from all characters.

```ruby
irb(main):020:0> str.no_diacritics
=> "Μηνιν αειδε θεα Πηληιαδεω Αχιληος"
```

## Accents

### `to_grave` (str → str)

Change the acute for a grave accent. Alternative name: `tonos_to_grave`

```ruby
irb(main):021:0> str = str.to_grave
=> "θεὰ"
```

### `to_acute` (str → str)

Change the grave for an acute accent. Alternative: `grave_to_acute`

```ruby
irb(main):022:0> str = str.to_acute
=> "θεά"
```

### `to_oxia` (str → str)

Tonos → Oxia. This should also be self-explanatory, but only if one is aware of the existence of two different types of acute accent for Greek letters in the Unicode system. If you didn't know, now you do.

The `tonos` was created when Greece adopted the monotonic system. It was considered a new kind of diacritical mark. Later, this changed and everyone agreed that it is, in fact, no different from the acute accent of polytonic greek.

When the Greek Extended Character Set was created specifically for polytonic Greek, however, another character was introduced to represent the acute accent. This character is called `oxia`.

The end result? Both characters are visually impossible to distinguish. The `tonos` is now the same as the `oxia` and the standard way to represent the acute accent when it is the only diacritical mark of the base character. Whenever you are typing, if you include other diacritics, it will automatically turn into an `oxia`. But, keep in mind that they have different code points, so one won't match against the other.

```ruby
irb(main):023:0> str = str.to_oxia
=> "θεά"

irb(main):024:0> str.unicode_name
=> ["GREEK SMALL LETTER THETA", "GREEK SMALL LETTER EPSILON", "GREEK SMALL LETTER ALPHA WITH OXIA"]
```

### `to_tonos` (str → str)

Oxia → Tonos. If in doubt about whether to use `oxia` or `tonos`, the correct answer is `tonos`. So, use this methods to convert an `oxia` to a `tonos`, in all cases where it should be used.

```ruby
irb(main):025:0> str = str.to_tonos
=> "θεά"

irb(main):026:0> str.unicode_name
=> ["GREEK SMALL LETTER THETA", "GREEK SMALL LETTER EPSILON", "GREEK SMALL LETTER ALPHA WITH TONOS"]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bcdav/grc. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/syntax-tree/.github/blob/main/code-of-conduct.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Grc project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/syntax-tree/.github/blob/main/code-of-conduct.md).
