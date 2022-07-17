```ruby
require 'grc'
```

## String contains greek letters? (str → bool)

Here we check for the presence or absence of greek letters in a string.

```ruby
irb(main):001:0> 'Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος'.grc?
=> true

irb(main):002:0> 'Greekless sentence'.grc?
=> false
```

## Tokenize string (str → array)

Now we tokenize a string into an array of greek words and punctuation.

```ruby
irb(main):02:0> 'Πάντες ἄνθρωποι τοῦ εἰδέναι ὀρέγονται φύσει. σημεῖον δ᾽ ἡ τῶν αἰσθήσεων ἀγάπησις· καὶ γὰρ χωρὶς τῆς χρείας ἀγαπῶνται δι᾽ αὑτάς, καὶ μάλιστα τῶν ἄλλων ἡ διὰ τῶν ὀμμάτων.'.tokenize
=> ["Πάντες", "ἄνθρωποι", "τοῦ", "εἰδέναι", "ὀρέγονται", "φύσει", ".", "σημεῖον", "δ᾽", "ἡ",
   "τῶν", "αἰσθήσεων", "ἀγάπησις", "·", "καὶ", "γὰρ", "χωρὶς", "τῆς", "χρείας", "ἀγαπῶνται",
   "δι᾽", "αὑτάς", ",", "καὶ", "μάλιστα", "τῶν", "ἄλλων", "ἡ", "διὰ", "τῶν", "ὀμμάτων", "."]

irb(main):004:0> 'Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος'.tokenize
=> ["Μῆνιν", "ἄειδε", "θεὰ", "Πηληϊάδεω", "Ἀχιλῆος"]
```

## Transliterate greek to latin (str → str) [EXPERIMENTAL]

```ruby
irb(main):005:0> 'Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος'.transliterate
=> "mēnin aeide thea pēlēiadeō achilēos"

irb(main):006:0> 'Πάντες ἄνθρωποι τοῦ εἰδέναι ὀρέγονται φύσει'.transliterate
=> "pantes anthrōpoi tou eidenai oregontai physei"
```

## Characters in string (str → array)

```ruby
irb(main):007:0> 'θεὰ'.unicode_char
=> ["θ", "ε", "ὰ"]
```

## Points of each character in string (str → array)

```ruby
irb(main):008:0> 'θεὰ'.unicode_points
=> ["\\u03B8", "\\u03B5", "\\u1F70"]
```

## Hash of chars and unicode_points (str → hash)

```ruby
irb(main):009:0> str.hash_dump
=> {"ἄ"=>"\"\\u1F04\"", "ε"=>"\"\\u03B5\"", "ι"=>"\"\\u03B9\"", "δ"=>"\"\\u03B4\""}
```

## Name of each character in string (str → array)

```ruby
irb(main):010:0> 'θεὰ'.unicode_name
=> ["GREEK SMALL LETTER THETA", "GREEK SMALL LETTER EPSILON", "GREEK SMALL LETTER ALPHA WITH VARIA"]
```

## Unicode Normalization

### Canonical Decomposition (NFD) (str → str)

```ruby
irb(main):011:0> str = 'ἄειδε'
=> "ἄειδε"

irb(main):012:0> str.unicode_char
=> ["ἄ", "ε", "ι", "δ", "ε"]

irb(main):013:0> str = str.nfd
=> "ἄειδε"

irb(main):014:0> str.unicode_char
=> ["α", "̓", "́", "ε", "ι", "δ", "ε"] # Longer row of characters after decomposition
```

### Canonical Composition (NFC) (str → str)

```ruby
irb(main):015:0> str = str.nfc
=> "ἄειδε"

irb(main):016:0> str.unicode_char
=> ["ἄ", "ε", "ι", "δ", "ε"] # Shorter row of characters after composition
```

## Change type of accent

```ruby
irb(main):017:0> str = 'θεά'
=> "θεά"
```

### Acute → Grave (str → str)

```ruby
irb(main):018:0> str = str.to_grave
=> "θεὰ"
```

### Grave → Acute (str → str)

```ruby
irb(main):019:0> str = str.to_acute
=> "θεά"
```

### Tonos → Oxia (str → str)

```ruby
irb(main):020:0> str = str.to_oxia
=> "θεά"

irb(main):021:0> str.unicode_name
=> ["GREEK SMALL LETTER THETA", "GREEK SMALL LETTER EPSILON", "GREEK SMALL LETTER ALPHA WITH OXIA"]
```

### Oxia → Tonos (str → str)

```ruby
irb(main):022:0> str = str.to_tonos
=> "θεά"

irb(main):023:0> str.unicode_name
=> ["GREEK SMALL LETTER THETA", "GREEK SMALL LETTER EPSILON", "GREEK SMALL LETTER ALPHA WITH TONOS"]
```

## Remove diacritical marks

```ruby
irb(main):024:0> str = 'Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος'
=> "Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος"
```

### From lowercase characters (str → str)

```ruby
irb(main):025:0> str.no_downcase_diacritics
=> "Μηνιν αειδε θεα Πηληιαδεω Ἀχιληος"
```

### From uppercase characters (str → str)

```ruby
irb(main):026:0> str.no_upcase_diacritics
=> "Μῆνιν ἄειδε θεὰ Πηληϊάδεω Αχιλῆος"
```

### From all characters (str → str)

```ruby
irb(main):027:0> str.no_diacritics
=> "Μηνιν αειδε θεα Πηληιαδεω Αχιληος"
```
