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
    assert_failure_message 'Expected 1 == 2 to be true' do
      1.must == 2
    end
  end

  def test_be_assertion_for_booleans
    [].must.be_empty
    nil.must.be_nil
    [].must_not.be_nil
    assert_failure_message 'Expected [] to be nil' do
      [].must.be_nil
    end
    assert_failure_message 'Expected nil to not be nil' do
      nil.must_not.be_nil
    end
  end

  def test_be_assertion_with_args
    [1, 2].must.include 1
    assert_failure_message 'Expected [1, 3] include 2 to be true' do
      [1, 3].must.include 2
    end
    assert_failure_message 'Expected {:foo=>1} has_key :bar to be true' do
      {:foo => 1}.must.has_key :bar
    end
  end

  def assert_failure_message(msg)
    begin
      yield
      assert_fail
    rescue MustardAssertionError => e
      assert_equal msg, e.to_s
    end
  end

end