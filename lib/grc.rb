# frozen_string_literal: true

require_relative 'grc/version'

# Methods for working with ancient greek in ruby
module Grc
  class Error < StandardError; end

  @std_error = 'ERROR: String does not contain any greek. Summon the muse and try again.'

  def grc?
    !scan(/(\p{Greek})/).empty?
  end

  def no_downcase_diacritics
    return @std_error unless grc?

    tr('ἀἄᾄἂᾂἆᾆᾀἁἅᾅἃᾃἇᾇᾁάάᾴὰᾲᾰᾶᾷᾱᾳἐἔἒἑἕἓέέὲἠἤᾔἢᾒἦᾖᾐἡἥᾕἣᾓἧᾗᾑήήῄὴῂῆῇῃἰἴἲἶἱἵἳἷίίὶῐῖϊϊΐῒῗῑὀὄὂὁὅὃόόὸῤῥὐὔὒὖὑὕὓὗύύὺῠῦϋΰΰΰῢῧῡὠὤᾤὢᾢὦᾦᾠὡὥᾥὣᾣὧᾧᾡώώῴὼῲῶῷῳ',
       'ααααααααααααααααααααααααααεεεεεεεεεηηηηηηηηηηηηηηηηηηηηηηηηιιιιιιιιιιιιιιιιιιιοοοοοοοοορρυυυυυυυυυυυυυυυυυυυυωωωωωωωωωωωωωωωωωωωωωωωω')
  end

  def no_upcase_diacritics
    return @std_error unless grc?

    str = self
    # Adhoc solution for odd combinations of diacritics with capital letters
    subs = [[/[́̀͂́́́̀͂]/, ''], [/Α͂/, 'Α'], [/Η͂/, 'Η'], [/Ί|Ὶ|Ι͂|́Ι|̀Ι|͂Ι/, 'Ι'], [/Ρ̓/, 'Ρ'], [/ Ὺ| ́Υ|Υ̓|Ύ|Ὺ|Υ͂|́Υ|̀Υ|͂Υ/, 'Υ'], [/͂Ω/, 'Ω']]
    subs.each { |a| str = str.gsub(/#{a[0]}/, a[1]) }
    str.tr('ἈἌἊἎἉἍἋἏΆᾺᾸᾹἘἜἚἙἝἛΈῈἨἬἪἮἩἭἫἯΉῊἸἼἺἾἹἽἻἿΊῚῘΪῙὈὌὊὉὍὋΌῸΡῬὙὝὛὟΎῪῨΫῩὨὬὪὮὩὭὫὯΏῺ',
           'ΑΑΑΑΑΑΑΑΑΑΑΑΕΕΕΕΕΕΕΕΗΗΗΗΗΗΗΗΗΗΙΙΙΙΙΙΙΙΙΙΙΙΙΟΟΟΟΟΟΟΟΡΡΥΥΥΥΥΥΥΥΥΩΩΩΩΩΩΩΩΩΩ')
  end

  def no_diacritics
    return @std_error unless grc?

    no_downcase_diacritics.no_upcase_diacritics
  end

  def tonos_to_oxia
    return @std_error unless grc?

    tr('άΆέΈήΉίΊΐόΌύΎΰώΏ',
       'άΆέΈήΉίΊΐόΌύΎΰώΏ')
  end

  def to_oxia
    return @std_error unless grc?

    tonos_to_oxia
  end

  def oxia_to_tonos
    return @std_error unless grc?

    tr('άΆέΈήΉίΊΐόΌύΎΰώΏ',
       'άΆέΈήΉίΊΐόΌύΎΰώΏ')
  end

  def to_tonos
    return @std_error unless grc?

    oxia_to_tonos
  end

  def acute_to_grave
    return @std_error unless grc?

    tr('ἄᾄἅᾅάάᾴἔἕέέἤᾔἥᾕήήῄἴἵίίΐὄὅόόὔὕύύΰΰὤᾤὥᾥώῴ',
       'ἂᾂἃᾃὰὰᾲἒἓὲὲἢᾒἣᾓὴὴῂἲἳὶὶῒὂὃὸὸὒὓὺὺῢῢὢᾢὣᾣὼῲ')
  end

  def grave_to_acute
    return @std_error unless grc?

    tr('ἂᾂἃᾃὰὰᾲἒἓὲὲἢᾒἣᾓὴὴῂἲἳὶὶῒὂὃὸὸὒὓὺὺῢῢὢᾢὣᾣὼῲ',
       'ἄᾄἅᾅάάᾴἔἕέέἤᾔἥᾕήήῄἴἵίίΐὄὅόόὔὕύύΰΰὤᾤὥᾥώῴ')
  end

  def to_grave
    return @std_error unless grc?

    acute_to_grave
  end

  def to_acute
    return @std_error unless grc?

    grave_to_acute
  end

  def tokenize
    gsub(/([[:punct:]]|·|·|‧|⸱|𐄁|\.|;|;)/, ' \1').split
  end

  def unicode_char
    each_char.map(&:to_s)
  end

  def unicode_name
    require 'unicode/name'
    each_char.map { |character| Unicode::Name.of character }
  end

  def unicode_points
    unpack('U*').map { |i| "\\u#{i.to_s(16).rjust(4, "0").upcase}" }
  end

  def hash_dump
    hash = {}
    each_char do |character|
      hash[character] = character.dump
    end
    hash
  end

  def transliterate
    return @std_error unless grc?

    hash = {
      ῥ: 'rh',
      ͱ: '',
      Ͳ: '',
      ͳ: '',
      ʹ: '',
      "\u0375": '',
      Ͷ: '',
      ͷ: '',
      ͺ: '',
      ͻ: '',
      ͼ: '',
      ͽ: '',
      Α: 'a',
      Β: 'b',
      Γ: 'g',
      Δ: 'd',
      Ε: 'e',
      Ζ: 'z',
      Η: 'ē',
      Θ: 'th',
      Ι: 'i',
      Κ: 'k',
      Λ: 'l',
      Μ: 'm',
      Ν: 'n',
      Ξ: 'x',
      Ο: 'o',
      Π: 'p',
      Ρ: 'r',
      Σ: 's',
      Τ: 't',
      Υ: 'y',
      Φ: 'ph',
      Χ: 'ch',
      Ψ: 'ps',
      Ω: 'ō',
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
      "\u03F6": '',
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
      "\u{0314}": 'rh',
      rr: 'rrh',
      ay: 'au',
      ey: 'eu',
      ēy: 'ēu',
      oy: 'ou',
      yi: 'ui'
    }
    result = []
    str = self
    str.split.each do |word|
      result << if word.grc?
                  the_word = word.gsub(/ῥ/, 'rh')
                  the_word = the_word =~ /[ἁἅᾅἃᾃἇᾇᾁἑἕἓἡἥᾕἣᾓἧᾗᾑἱἵἳἷὁὅὃὑὕὓὗὡὥᾥὣᾣὧᾧᾡ]/ ? "h#{the_word.no_diacritics}" : the_word.no_diacritics
                  hash.each { |k, v| the_word = the_word.gsub(/#{k}/, v) }
                  the_word
                else
                  word
                end
    end
    result.join(' ')
  end

  def nfc
    unicode_normalize(:nfc)
  end

  def nfd
    unicode_normalize(:nfd)
  end
end

class String
  include Grc
end
