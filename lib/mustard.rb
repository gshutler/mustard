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
    evaluate(:==, expected)
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
    evaluate :===, expected
  end

  def respond_to?(symbol)
    evaluate :respond_to?, symbol
  end

  def method_missing(symbol, *args)
    if @value.respond_to? symbol
      evaluate symbol, *args
    elsif @value.respond_to? "#{symbol}?".to_sym
      evaluate "#{symbol}?", *args
    elsif @value.respond_to? "#{symbol}!".to_sym
      evaluate "#{symbol}!", *args
    elsif symbol.to_s.start_with? 'be_'
      method_missing symbol.to_s[3..-1], *args
    else
      super
    end
  end

  private

  def evaluate(symbol, *args)
    symbol = symbol.to_sym unless symbol.instance_of? Symbol
    if (@value.send symbol, *args) == @desired_result
      true
    elsif args.size == 0 and @desired_result
      failed_assertion "Expected #{print_val @value} to be #{plain_symbol symbol}"
    elsif args.size == 0
      failed_assertion "Expected #{print_val @value} to not be #{plain_symbol symbol}"
    elsif args.size == 1
      failed_assertion "Expected #{print_val @value} #{plain_symbol symbol} #{print_val args[0]} to be #{@desired_result}"
    else
      failed_assertion "Expected #{print_val @value}.#{plain_symbol symbol}(#{args.map{ |a| print_val a }.join(', ')}) to be #{@desired_result}"
    end
  end

  def plain_symbol(symbol)
    symbol.to_s.gsub(/[\?\!]$/, '')
  end

  def print_val(value)
    if value.nil?
      'nil'
    elsif value.instance_of? Symbol
      ":#{value}"
    else
      value
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