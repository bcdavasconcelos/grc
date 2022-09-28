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

    result = []
    str = self
    str.tokenize do |token|
      result << if token.grc?
                  the_word = token.gsub(/ῥ/, 'rh')
                  the_word = the_word =~ /[ἁἅᾅἃᾃἇᾇᾁἑἕἓἡἥᾕἣᾓἧᾗᾑἱἵἳἷὁὅὃὑὕὓὗὡὥᾥὣᾣὧᾧᾡ]/ ? "h#{the_word.no_diacritics}" : the_word.no_diacritics
                  hash.each { |k, v| the_word = the_word.gsub(/#{k}/, v) }
                  the_word
                else
                  word
                end
    end
    result.join(' ')
  end

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
  # https://icu.unicode.org/design/case/greek-upper
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

    # Simple transform method with grave to acute mapping
    tr('ἄᾄἅᾅάάᾴἔἕέέἤᾔἥᾕήήῄἴἵίίΐὄὅόόὔὕύύΰΰὤᾤὥᾥώῴ',
       'ἂᾂἃᾃὰὰᾲἒἓὲὲἢᾒἣᾓὴὴῂἲἳὶὶῒὂὃὸὸὒὓὺὺῢῢὢᾢὣᾣὼῲ')
  end

  # `to_acute` (str → str)
  # Returns a string with the acute replacing the grave accent.
  def to_acute
    return @std_error unless grc?

    # Simple transform method with acute to grave mapping
    tr('ἂᾂἃᾃὰὰᾲἒἓὲὲἢᾒἣᾓὴὴῂἲἳὶὶῒὂὃὸὸὒὓὺὺῢῢὢᾢὣᾣὼῲ',
       'ἄᾄἅᾅάάᾴἔἕέέἤᾔἥᾕήήῄἴἵίίΐὄὅόόὔὕύύΰΰὤᾤὥᾥώῴ')
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

  def oxia_to_tonos
    return @std_error unless grc?

    to_tonos
  end

  def tonos_to_oxia
    return @std_error unless grc?

    to_oxia
  end

  def grave_to_acute
    return @std_error unless grc?

    to_acute
  end

  def acute_to_grave
    return @std_error unless grc?

    to_grave
  end

end


class String
  include Grc
end
