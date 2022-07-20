# frozen_string_literal: true

require_relative 'grc/version'

# Methods for working with ancient greek in ruby
module Grc
  class Error < StandardError; end

  @std_error = 'ERROR: String does not contain any greek. Summon the muse and try again.'

  # General methods

  # `grc?` (str → bool)
  # Returns true if the string contains greek characters.
  def grc?
    !scan(/(\p{Greek})/).empty?
  end

  # `tokenize` (str → array)
  # Returns an array of tokens from the string.
  def tokenize
    gsub(/([[:punct:]]|·|·|‧|⸱|𐄁|\.|;|;)/, ' \1').split
  end

  # `transliterate` (str → str)
  # Returns a string with greek characters replaced with their transliteration.
  def transliterate
    return @std_error unless grc?

    transliteration_map = {
      ῥ: 'rh',
      ͱ: '',
      Ͳ: '',
      ͳ: '',
      ʹ: '',
      ͵: '',
      Ͷ: '',
      ͷ: '',
      ͺ: '',
      ͻ: '',
      ͼ: '',
      ͽ: '',
      Α: 'A',
      Β: 'B',
      Γ: 'G',
      Δ: 'D',
      Ε: 'E',
      Ζ: 'Z',
      Η: 'Ē',
      Θ: 'TH',
      Ι: 'I',
      Κ: 'K',
      Λ: 'L',
      Μ: 'M',
      Ν: 'N',
      Ξ: 'X',
      Ο: 'O',
      Π: 'P',
      Ρ: 'R',
      Σ: 'S',
      Τ: 'T',
      Υ: 'Y',
      Φ: 'PH',
      Χ: 'CH',
      Ψ: 'PS',
      Ω: 'Ō',
      α: 'a',
      β: 'b',
      γ: 'g',
      δ: 'd',
      ε: 'e',
      ζ: 'z',
      η: 'ē',
      θ: 'th',
      ι: 'i',
      κ: 'k',
      λ: 'l',
      μ: 'm',
      ν: 'n',
      ξ: 'x',
      ο: 'o',
      π: 'p',
      ρ: 'r',
      ς: 's',
      σ: 's',
      τ: 't',
      υ: 'y',
      φ: 'ph',
      χ: 'ch',
      ψ: 'ps',
      ω: 'ō',
      Ϗ: '',
      ϐ: '',
      ϑ: '',
      ϒ: '',
      ϓ: '',
      ϔ: '',
      ϕ: '',
      ϖ: '',
      ϗ: '',
      Ϙ: '',
      ϙ: '',
      Ϛ: '',
      ϛ: '',
      Ϝ: '',
      ϝ: '',
      Ϟ: '',
      ϟ: '',
      Ϡ: '',
      ϡ: '',
      Ϣ: '',
      ϣ: '',
      Ϥ: '',
      ϥ: '',
      Ϧ: '',
      ϧ: '',
      Ϩ: '',
      ϩ: '',
      Ϫ: '',
      ϫ: '',
      Ϭ: '',
      ϭ: '',
      Ϯ: '',
      ϯ: '',
      ϰ: '',
      ϱ: '',
      ϲ: '',
      ϳ: '',
      ϴ: '',
      ϵ: '',
      ϶: '',
      Ϸ: '',
      ϸ: '',
      Ϲ: '',
      Ϻ: '',
      ϻ: '',
      ϼ: '',
      Ͻ: '',
      Ͼ: '',
      Ͽ: '',
      gg: 'ng',
      gk: 'nk',
      gx: 'nx',
      gc: 'nc',
      rr: 'rrh',
      ay: 'au',
      ey: 'eu',
      ēy: 'ēu',
      oy: 'ou',
      yi: 'ui'
    }
    str = self
    str = each_char.map { |c| transliteration_map[:"#{c}"] || c.nfd.gsub(/\p{Mn}/, '') }.join
    str = str.each_char.map { |c|
      if transliteration_map.keys.include? c
        transliteration_map[c]
      elsif transliteration_map.keys.include? :"#{c}"
        transliteration_map[:"#{c}"]
      elsif transliteration_map.keys.include? c.nfd.gsub(/\p{Mn}/, '')
        transliteration_map[c.nfd.gsub(/\p{Mn}/, '')]
      elsif transliteration_map.keys.include? :"#{c.nfd.gsub(/\p{Mn}/, '')}"
        transliteration_map[:"#{c.nfd.gsub(/\p{Mn}/, '')}"]
      else
        c.nfd.gsub(/\p{Mn}/, '')
      end
    }.join

    end
  # result = []
    # str = self
    # str.split.each do |word|
    #   result << if word.grc?
    #               the_word = word.gsub(/ῥ/, 'rh')
    #               the_word = the_word =~ /[ἁἅᾅἃᾃἇᾇᾁἑἕἓἡἥᾕἣᾓἧᾗᾑἱἵἳἷὁὅὃὑὕὓὗὡὥᾥὣᾣὧᾧᾡ]/ ? "h#{the_word.no_diacritics}" : the_word.no_diacritics
    #               hash.each { |k, v| the_word = the_word.gsub(/#{k}/, v) }
    #               the_word
    #             else
    #               word
    #             end
    # end
    # result.join(' ')
  # end

  # Unicode Inspection Methods

  # `unicode_points` (str → array)
  # Returns an array of unicode points from the string.
  def unicode_points
    unpack('U*').map { |i| "\\u#{i.to_s(16).rjust(4, "0").upcase}" }
  end

  # `hash_dump`: (str → hash)
  # Returns a hash of the string's unicode points (Char: Unicode_points).
  def hash_dump
    hash = {}
    each_char do |character|
      hash[character] = character.dump
    end
    hash
  end

  # `unicode_name` (str → array)
  # Returns an array of unicode names from the string.
  def unicode_name
    require 'unicode/name'
    each_char.map { |character| Unicode::Name.of character }
  end

  # Unicode Normalization

  # `nfd` (str → str)
  # Returns a string with the canonical decomposition of the string.
  def nfd
    unicode_normalize(:nfd)
  end

  # `nfc` (str → str)
  # Returns a string with the canonical composition of the string.
  def nfc
    unicode_normalize(:nfc)
  end

  # Case folding

  # `grc_downcase` (str → str)
  # Returns the lowercase version of string for greek characters resolving confusable characters.
  # See https://www.w3.org/TR/charmod-norm/#PreNormalization
  def grc_downcase
    nfd.downcase.nfc
  end

  # `grc_upcase` (str → str)
  # Default `upcase` methods strips diacritical marks from greek characters.
  # This method returns the corresponding uppercase version of string for greek characters preserving diacritical marks.
  # See pages 1-7 of http://www.tlg.uci.edu/encoding/precomposed.pdf
  def grc_upcase

    case_map = {
      ᾀ: 'ᾈ',
      ᾁ: 'ᾉ',
      ᾂ: 'ᾊ',
      ᾃ: 'ᾋ',
      ᾄ: 'ᾌ',
      ᾅ: 'ᾍ',
      ᾆ: 'ᾎ',
      ᾇ: 'ᾏ',
      ᾐ: 'ᾘ',
      ᾑ: 'ᾙ',
      ᾒ: 'ᾚ',
      ᾓ: 'ᾛ',
      ᾔ: 'ᾜ',
      ᾕ: 'ᾝ',
      ᾖ: 'ᾞ',
      ᾗ: 'ᾟ',
      ᾠ: 'ᾨ',
      ᾡ: 'ᾩ',
      ᾢ: 'ᾪ',
      ᾣ: 'ᾫ',
      ᾤ: 'ᾬ',
      ᾥ: 'ᾭ',
      ᾦ: 'ᾮ',
      ᾧ: 'ᾯ',
      ᾳ: 'ᾼ',
      ῃ: 'ῌ',
      ῳ: 'ῼ'
    }

    nfc.each_char.map do |char|
      if char.grc?
        case_map[:"#{char}"] || char.upcase
      else
        char
      end
    end.join
  end

  # Diacritical marks

  # `no_downcase_diacritics` (str → str)
  # Returns a string with the diacritics removed from lowercase characters.
  def no_downcase_diacritics
    return @std_error unless grc?

    each_char.map do |char| # Loop through each character
      if char.grc? && char.lower? # If character is greek and lowercase
        char.nfd.gsub(/\p{Mn}/, '').nfc # decompose, remove non-spacing markers (diacritics), recompose and return
      else # else
        char # return char
      end
    end.join # end char loop
  end

  # `no_upcase_diacritics` (str → str)
  # Returns a string with the diacritics removed from uppercase characters.
  def no_upcase_diacritics
    return @std_error unless grc?

    each_char.map do |char| # Loop through each character
      if char.grc? && char.upper? # If character is greek and uppercase
        char.nfd.gsub(/\p{Mn}/, '').nfc # Decompose, remove non-spacing markers (diacritics), recompose and return
      else # else
        char # Return char
      end
    end.join
  end

  # `no_diacritics` (str → str)
  # Returns a string with the diacritics removed.
  def no_diacritics
    return @std_error unless grc?

    no_downcase_diacritics.no_upcase_diacritics
  end

  # Accents

  # `to_grave` (str → str)
  # Returns a string with the grave replacing the acute accent.
  def to_grave
    return @std_error unless grc?

    tr('ἂᾂἃᾃὰὰᾲἒἓὲὲἢᾒἣᾓὴὴῂἲἳὶὶῒὂὃὸὸὒὓὺὺῢῢὢᾢὣᾣὼῲ', # Simple transform method with grave to acute mapping
       'ἄᾄἅᾅάάᾴἔἕέέἤᾔἥᾕήήῄἴἵίίΐὄὅόόὔὕύύΰΰὤᾤὥᾥώῴ')
  end

  # `to_acute` (str → str)
  # Returns a string with the acute replacing the grave accent.
  def to_acute
    return @std_error unless grc?

    tr('ἄᾄἅᾅάάᾴἔἕέέἤᾔἥᾕήήῄἴἵίίΐὄὅόόὔὕύύΰΰὤᾤὥᾥώῴ', # Simple transform method with acute to grave mapping
       'ἂᾂἃᾃὰὰᾲἒἓὲὲἢᾒἣᾓὴὴῂἲἳὶὶῒὂὃὸὸὒὓὺὺῢῢὢᾢὣᾣὼῲ')
  end

  # `to_oxia` (str → str)
  # Returns a string with the oxia replacing the tonos.
  def to_oxia
    return @std_error unless grc?

    tr('άΆέΈήΉίΊΐόΌύΎΰώΏ',
       'άΆέΈήΉίΊΐόΌύΎΰώΏ')
  end

  # `to_tonos` (str → str)
  # Returns a string with the tonos replacing the oxia.
  # See page 9 of http://www.tlg.uci.edu/encoding/precomposed.pdf
  def to_tonos
    return @std_error unless grc?

    tr('άΆέΈήΉίΊΐόΌύΎΰώΏ',
       'άΆέΈήΉίΊΐόΌύΎΰώΏ')
  end

  def upper?
    !!match(/\p{Upper}/)
  end

  def lower?
    !!match(/\p{Lower}/)
  end
end

class String
  include Grc
end


# require 'unicode/data'

# 'ἀἄᾄἂᾂἆᾆᾀἁἅᾅἃᾃἇᾇᾁάάᾴὰᾲᾰᾶᾷᾱᾳἐἔἒἑἕἓέέὲἠἤᾔἢᾒἦᾖᾐἡἥᾕἣᾓἧᾗᾑήήῄὴῂῆῇῃἰἴἲἶἱἵἳἷίίὶῐῖϊϊΐῒῗῑὀὄὂὁὅὃόόὸῤῥὐὔὒὖὑὕὓὗύύὺῠῦϋΰΰΰῢῧῡὠὤᾤὢᾢὦᾦᾠὡὥᾥὣᾣὧᾧᾡώώῴὼῲῶῷῳἈἌἊἎἉἍἋἏΆᾺᾸᾹἘἜἚἙἝἛΈῈἨἬἪἮἩἭἫἯΉῊἸἼἺἾἹἽἻἿΊῚῘΪῙὈὌὊὉὍὋΌῸΡῬὙὝὛὟΎῪῨΫῩὨὬὪὮὩὭὫὯΏῺ'.nfd.each_char do |char|
#   p char unless Unicode::Data.property?('\p{General_Category=Mn}', char)
# end
# p Unicode::Data.property?('\p{General_Category=Mn}', 'ἄ')

# str = 'ἄνθρωπος'
# str_nfc = str.nfc
# str_nfd = str.nfd
# query = 'ανθρ'
#
# p str_nfc.match('ανθρ')
# p str_nfd.match('ανθρ')

# ᾌ [U+1F8C GREEK CAPITAL LETTER ALPHA WITH PSILI AND OXIA AND PROSGEGRAMMENI] → ἄι [U+1F04 GREEK SMALL LETTER ALPHA WITH PSILI AND OXIA + U+03B9 GREEK SMALL LETTER IOTA]
# ᾌ [U+0391 GREEK CAPITAL LETTER ALPHA + U+0313 COMBINING COMMA ABOVE + U+0301 COMBINING ACUTE ACCENT + U+0345 COMBINING GREEK YPOGEGRAMMENI]


# str = 'ᾌ'.nfc
# p str.downcase
# p str.upcase
# p str.grc_upcase
# p str.nfc.unicode_name
# # p str.nfd.unicode_name
# p str.nfc.downcase.unicode_name
# p str.downcase.nfc.upcase.nfc.unicode_name
s = 'ὊὉὍὋΌῸἈάἀἄᾄἂᾂἆéáàìò'
# p s.no_upcase_diacritics
# p s.no_downcase_diacritics
# p s.no_diacritics
str = 'Πάντες ἄνθρωποι τοῦ εἰδέναι ὀρέγονται φύσει. σημεῖον δ᾽ ἡ τῶν αἰσθήσεων ἀγάπησις· καὶ γὰρ χωρὶς τῆς χρείας ἀγαπῶνται δι᾽ αὑτάς, καὶ μάλιστα τῶν ἄλλων ἡ διὰ τῶν ὀμμάτων.'
p str.transliterate

# p 'ἀἄᾄἂᾂ'.upcase
# puts 'ᾄἂᾂ'.grc_upcase
