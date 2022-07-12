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
    tr('ἈἌἌΙἊἊΙἎἎΙἈΙἉἍἍΙἋἋΙἏἏΙἉΙΆΆΆΙᾺᾺΙᾸΑ͂Α͂ΙᾹΑΙἘἜἚἙἝἛΈΈῈἨἬἬΙἪἪΙἮἮΙἨΙἩἭἭΙἫἫΙἯἯΙἩΙΉΉΉΙῊῊΙΗ͂Η͂ΙΗΙἸἼἺἾἹἽἻἿΊΊῚῘΙ͂ΪΪΪ́Ϊ̀Ϊ͂ῙὈὌὊὉὍὋΌΌῸΡ̓ῬΥ̓Υ̓́Υ̓̀Υ̓͂ὙὝὛὟΎΎῪῨΥ͂ΫΫ́Ϋ́Ϋ́Ϋ̀Ϋ͂ῩὨὬὬΙὪὪΙὮὮΙὨΙὩὭὭΙὫὫΙὯὯΙὩΙΏΏΏΙῺῺΙΩ͂Ω͂ΙΩΙ',
       'ΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΕΕΕΕΕΕΕΕΕΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΟΟΟΟΟΟΟΟΟΡΡΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩ')
  end

  def no_diacritics
    tr('ἀἄᾄἂᾂἆᾆᾀἁἅᾅἃᾃἇᾇᾁάάᾴὰᾲᾰᾶᾷᾱᾳἐἔἒἑἕἓέέὲἠἤᾔἢᾒἦᾖᾐἡἥᾕἣᾓἧᾗᾑήήῄὴῂῆῇῃἰἴἲἶἱἵἳἷίίὶῐῖϊϊΐῒῗῑὀὄὂὁὅὃόόὸῤῥὐὔὒὖὑὕὓὗύύὺῠῦϋΰΰΰῢῧῡὠὤᾤὢᾢὦᾦᾠὡὥᾥὣᾣὧᾧᾡώώῴὼῲῶῷῳἈἌἌΙἊἊΙἎἎΙἈΙἉἍἍΙἋἋΙἏἏΙἉΙΆΆΆΙᾺᾺΙᾸΑ͂Α͂ΙᾹΑΙἘἜἚἙἝἛΈΈῈἨἬἬΙἪἪΙἮἮΙἨΙἩἭἭΙἫἫΙἯἯΙἩΙΉΉΉΙῊῊΙΗ͂Η͂ΙΗΙἸἼἺἾἹἽἻἿΊΊῚῘΙ͂ΪΪΪ́Ϊ̀Ϊ͂ῙὈὌὊὉὍὋΌΌῸΡ̓ῬΥ̓Υ̓́Υ̓̀Υ̓͂ὙὝὛὟΎΎῪῨΥ͂ΫΫ́Ϋ́Ϋ́Ϋ̀Ϋ͂ῩὨὬὬΙὪὪΙὮὮΙὨΙὩὭὭΙὫὫΙὯὯΙὩΙΏΏΏΙῺῺΙΩ͂Ω͂ΙΩΙ',
       'ααααααααααααααααααααααααααεεεεεεεεεηηηηηηηηηηηηηηηηηηηηηηηηιιιιιιιιιιιιιιιιιιιοοοοοοοοορρυυυυυυυυυυυυυυυυυυυυωωωωωωωωωωωωωωωωωωωωωωωωΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΑΕΕΕΕΕΕΕΕΕΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΗΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΙΟΟΟΟΟΟΟΟΟΡΡΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΥΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩ')
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
