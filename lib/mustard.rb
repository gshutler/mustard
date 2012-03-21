
class Mustard

  def initialize(value, desired_result = true)
    @value = value
    @desired_result = desired_result
  end

  def not
    @desired_result = !@desired_result
    self
  end

  def ==(expected)
    unless (@value == expected) == @desired_result
      raise MustardAssertionError, "Expected #{expected} but got #{@value}"
    end
    true
  end

  def !=(expected)
    evaluate :!=, expected
  end

  def equal?(expected)
    evaluate :equal?, expected
  end

  def eql?(expected)
    evaluate :eql?, expected
  end

  def ===(expected)
    unless (expected.send :===, @value) == @desired_result
      throw "Expected to be able to infer #{other} from #{@value} but could not"
    end
    true
  end

  def respond_to?(symbol)
    evaluate :respond_to?, symbol
  end

  def method_missing(symbol, args)
    if @value.respond_to? symbol
      evaluate symbol, *args
    elsif @value.respond_to? "#{symbol}?".to_sym
      evaluate "#{symbol}?".to_sym, *args
    elsif @value.respond_to? "#{symbol}!".to_sym
      evaluate "#{symbol}!".to_sym, *args
    else
      super
    end
  end

  private

  def evaluate(symbol, *args)
    unless (@value.send symbol, *args) == @desired_result
      raise "Expected #{@value} #{symbol} #{other} to be #{@desired_result} but it wasn't"
    end
    true
  end

end

class MustardAssertionError < RuntimeError

  def initialize(msg)
    @msg = msg
  end

  def to_s
    @msg
  end

end

class Object

  def must
    Mustard.new self
  end

  def must_not
    Mustard.new self, false
  end

end