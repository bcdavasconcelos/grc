# frozen_string_literal: true

require_relative 'grc/version'

# Methods for working with ancient greek in ruby
module Grc
  class Error < StandardError; end

  def grc?
    !scan(/(\p{Greek})/).empty?
  end

  def no_downcase_diacritics
    tr('ἀἄᾄἂᾂἆᾆᾀἁἅᾅἃᾃἇᾇᾁάάᾴὰᾲᾰᾶᾷᾱᾳἐἔἒἑἕἓέέὲἠἤᾔἢᾒἦᾖᾐἡἥᾕἣᾓἧᾗᾑήήῄὴῂῆῇῃἰἴἲἶἱἵἳἷίίὶῐῖϊϊΐῒῗῑὀὄὂὁὅὃόόὸῤῥὐὔὒὖὑὕὓὗύύὺῠῦϋΰΰΰῢῧῡὠὤᾤὢᾢὦᾦᾠὡὥᾥὣᾣὧᾧᾡώώῴὼῲῶῷῳ',
       'ααααααααααααααααααααααααααεεεεεεεεεηηηηηηηηηηηηηηηηηηηηηηηηιιιιιιιιιιιιιιιιιιιοοοοοοοοορρυυυυυυυυυυυυυυυυυυυυωωωωωωωωωωωωωωωωωωωωωωωω')
  end

  def no_upcase_diacritics
    str = self
    ars = [[/[́̀͂́́́̀͂]/, ''], [/Α͂/, 'Α'], [/Η͂/, 'Η'], [/Ί|Ὶ|Ι͂|́Ι|̀Ι|͂Ι/, 'Ι'],
           [/Ρ̓/, 'Ρ'], [/ Ὺ| ́Υ|Υ̓|Ύ|Ὺ|Υ͂|́Υ|̀Υ|͂Υ/, 'Υ'], [/͂Ω/, 'Ω']] # Adhoc solution for crazy diacritics with capital letters
    ars.each do |a|
      str = str.gsub(/#{a[0]}/, a[1])
    end
    str = str.tr('ἈἌἊἎἉἍἋἏΆᾺᾸᾹἘἜἚἙἝἛΈῈἨἬἪἮἩἭἫἯΉῊἸἼἺἾἹἽἻἿΊῚῘΪῙὈὌὊὉὍὋΌῸΡῬὙὝὛὟΎῪῨΫῩὨὬὪὮὩὭὫὯΏῺ',
                 'ΑΑΑΑΑΑΑΑΑΑΑΑΕΕΕΕΕΕΕΕΗΗΗΗΗΗΗΗΗΗΙΙΙΙΙΙΙΙΙΙΙΙΙΟΟΟΟΟΟΟΟΡΡΥΥΥΥΥΥΥΥΥΩΩΩΩΩΩΩΩΩΩ')
  end

  def no_diacritics
    no_downcase_diacritics.no_upcase_diacritics
  end

  def tonos_to_oxia
    tr('ΆΈΉΊΎΌΏάέήίΐύΰόώ',
       'ΆΈΉΊΎΌΏάέήίΐύΰόώ')
  end

  def oxia_to_tonos
    tr('ΆΈΉΊΎΌΏάέήίΐύΰόώ',
       'ΆΈΉΊΎΌΏάέήίΐύΰόώ')
  end

  def acute_to_grave
    tr('ἄᾄἅᾅάάᾴἔἕέέἤᾔἥᾕήήῄἴἵίίΐὄὅόόὔὕύύΰΰὤᾤὥᾥώῴ',
       'ἂᾂἃᾃὰὰᾲἒἓὲὲἢᾒἣᾓὴὴῂἲἳὶὶῒὂὃὸὸὒὓὺὺῢῢὢᾢὣᾣὼῲ')
  end

  def grave_to_acute
    tr('ἂᾂἃᾃὰὰᾲἒἓὲὲἢᾒἣᾓὴὴῂἲἳὶὶῒὂὃὸὸὒὓὺὺῢῢὢᾢὣᾣὼῲ',
       'ἄᾄἅᾅάάᾴἔἕέέἤᾔἥᾕήήῄἴἵίίΐὄὅόόὔὕύύΰΰὤᾤὥᾥώῴ')
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
