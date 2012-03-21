require 'test/unit'
require_relative '../lib/mustard'

class BobTest < MiniTest::Unit::TestCase

  def test_equal_values_return_true_when_checked_for_equality
    assert 1.must == 1
  end

  def test_unequal_values_return_true_when_checked_for_inequality
    assert 1.must != 2
  end

  def test_references_to_the_same_object_return_true_when_equal_checked
    a = :symbol
    b = :symbol
    assert a.must.equal? b
  end

  def test_references_to_different_objects_return_true_when_not_equal_checked
    a = 'string'
    b = 'string'
    assert a.must_not.equal? b
  end

  def test_references_to_the_same_object_return_true_when_eql_checked
    a = :symbol
    b = :symbol
    assert a.must.eql? b
  end

  def test_references_to_different_objects_return_true_when_not_eql_checked
    assert 1.must_not.eql? 2
  end

  def test_value_comparison
    assert 1.must < 2
    assert 2.must > 1
    assert 1.must <= 1
    assert 1.must <= 2
    assert 1.must >= 1
    assert 2.must >= 1
  end

  def test_inferred_equality
    assert 1.must === Fixnum
  end

  def test_proxied_methods
    assert ''.must.respond_to? :size
    assert 'bob'.must.start_with? 'b'
  end

  def test_removing_punctuation_from_proxied_methods
    assert 'bob'.must.start_with 'b'
  end

  def test_negation
    assert 1.must_not == 2
    assert 1.must.not == 2
    # check it will continue flipping if people hate themselves
    assert 1.must.not.not == 1
  end

  def test_assertion_messages
    assert_raises MustardAssertionError do
      1.must == 2
    end
  end

end