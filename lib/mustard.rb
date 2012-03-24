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
    if (@value == expected) == @desired_result
      true
    else
      raise MustardAssertionError, "Expected #{expected} but got #{@value}"
    end
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
    if (expected.send :===, @value) == @desired_result
      true
    else
      throw "Expected to be able to infer #{other} from #{@value} but could not"
    end
  end

  def respond_to?(symbol)
    evaluate :respond_to?, symbol
  end

  def method_missing(symbol, *args)
    if @value.respond_to? symbol
      evaluate symbol, *args
    elsif @value.respond_to? "#{symbol}?".to_sym
      evaluate "#{symbol}?".to_sym, *args
    elsif @value.respond_to? "#{symbol}!".to_sym
      evaluate "#{symbol}!".to_sym, *args
    elsif symbol.to_s.start_with? 'be_'
      method_missing(symbol.to_s[3..-1].to_sym, *args)
    else
      super
    end
  end

  private

  def evaluate(symbol, *args)
    if (@value.send symbol, *args) == @desired_result
      true
    elsif args.size == 1
      failed_assertion "Expected #{@value} #{symbol} #{args[0]} to be #{@desired_result}"
    else
      failed_assertion "Expected #{@value} to be #{symbol}"
    end
  end

  def failed_assertion(msg)
    raise MustardAssertionError.new msg
  end

end

class MustardAssertionError < MiniTest::Assertion

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