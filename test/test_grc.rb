# frozen_string_literal: true

require 'test_helper'
require 'coveralls'

Coveralls.wear!

class TestGrc < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Grc::VERSION
  end

  def test_grc?
    assert_equal true, 'α'.grc?
  end

  def test_not_grc?
    assert_equal false, 'a'.grc?
  end

  def test_no_downcase_diacritics
    assert_equal 'α', 'ἄ'.no_downcase_diacritics
  end

  def test_no_upcase_diacritics
    assert_equal 'Α', 'Ἀ'.no_upcase_diacritics
  end

  def test_no_diacritics
    assert_equal 'αΑ', 'ἄἈ'.no_diacritics
  end

  def test_tonos_to_oxia
    assert 'ά'.to_oxia.unicode_name.join =~ /OXIA/ && 'έ'.to_oxia.unicode_name.join =~ /OXIA/
    assert 'ί'.to_oxia.unicode_name.join =~ /OXIA/ && 'ή'.to_oxia.unicode_name.join =~ /OXIA/
    assert 'ό'.to_oxia.unicode_name.join =~ /OXIA/ && 'ύ'.to_oxia.unicode_name.join =~ /OXIA/
    assert 'ώ'.to_oxia.unicode_name.join =~ /OXIA/
  end

  def test_oxia_to_tonos
    assert_equal 'ά', 'ά'.oxia_to_tonos
    assert 'άΆ'.to_tonos.unicode_name.join =~ /TONOS/ && 'έΈ'.to_tonos.unicode_name.join =~ /TONOS/
    assert 'ήΉ'.to_tonos.unicode_name.join =~ /TONOS/ && 'ίΊΐ'.to_tonos.unicode_name.join =~ /TONOS/
    assert 'όΌ'.to_tonos.unicode_name.join =~ /TONOS/ && 'ύΎΰ'.to_tonos.unicode_name.join =~ /TONOS/
    assert 'ώΏ'.to_tonos.unicode_name.join =~ /TONOS/
  end

  def test_acute_to_grave
    assert_equal 'ά', 'ὰ'.grave_to_acute
  end

  def test_grave_to_acute
    assert_equal 'ὰ', 'ά'.acute_to_grave
  end

  def test_tokenization
    assert_equal %w[σημεῖον δ᾽ ἡ τῶν αἰσθήσεων ἀγάπησις · καὶ γὰρ χωρὶς τῆς χρείας ἀγαπῶνται δι᾽ αὑτάς], 'σημεῖον δ᾽ ἡ τῶν αἰσθήσεων ἀγάπησις· καὶ γὰρ χωρὶς τῆς χρείας ἀγαπῶνται δι᾽ αὑτάς'.tokenize
  end

  def test_unicode_char
    assert_equal ['α'], 'α'.unicode_char
  end

  def test_unicode_name
    assert_equal ['GREEK SMALL LETTER ALPHA'], 'α'.unicode_name
  end

  def test_unicode_points
    assert_equal ['\\u03B1'], 'α'.unicode_points
  end

  def test_nfc_normalization
    assert_equal 'ᾄ', 'ᾄ'.nfc
  end

  def test_nfd_normalization
    assert_equal 'ᾄ', 'ᾄ'.nfd
  end

  def test_transliteration_of_greek_to_latin; end

  def test_it_does_something_useful
    assert true
  end
end
