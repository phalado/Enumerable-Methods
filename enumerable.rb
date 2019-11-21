# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    while i < length
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    while i < length
      yield(self[i], i)
      i += 1
    end
  end

  def my_select
    return to_enum unless block_given?

    new_array = []
    my_each { |x| new_array << x if yield(x) }
    new_array
  end

  def my_all?(pat = nil)
    answer = true
    if block_given?
      my_each { |x| answer = false unless yield(x) }
    elsif pat
      my_each { |x| answer = false unless pattern?(x, pat) }
    else
      my_each { |x| answer = false unless x }
    end
    answer
  end

  def my_any?(pat = nil)
    answer = false
    if block_given?
      my_each { |x| answer = true if yield(x) }
    elsif pat
      my_each { |x| answer = true if pattern?(x, pat) }
    else
      my_each { |x| answer = true unless x }
    end
    answer
  end

  def my_none?(pat = nil)
    answer = true
    if block_given?
      my_each { |x| answer = false if yield(x) }
    elsif pat
      my_each { |x| answer = false if pattern?(x, pat) }
    else
      my_each { |x| answer = false if x }
    end
    answer
  end

  def my_count(arg = nil)
    counter = 0
    if block_given?
      my_each { |x| counter += 1 if yield(x) }
    elsif arg
      my_each { |x| counter += 1 if x == arg }
    else
      counter = length
    end
    counter
  end

  def my_map(param = nil)
    return to_enum unless block_given?

    new_array = []
    if block_given?
      my_each { |x| new_array << yield(x) }
    else
      my_each { |x| new_array << param.call(x) }
    end
    new_array
  end

  def my_inject(*args)
    answer, sym = inj_param(*args)
    answer = yield(0, 1).zero? ? 1 : 0
    if block_given?
      my_each { |x| answer = yield(answer, x) }
    elsif arg
      my_each { |x| answer = answer.public_send(sym, x) }
    end
    answer
  end

  def multiply_els
    my_inject { |x, y| x * y }
  end

  def pattern?(obj, pat)
    (obj.respond_to?(:eql?) && obj.eql?(pat)) ||
      (pat.is_a?(Class) && obj.is_a?(pat)) ||
      (pat.is_a?(Regexp) && pat.match(obj))
  end

  def inj_param(*args)
    answer, sym = nil
    args.my_each do |arg|
      answer = arg if arg.is_a? Numeric
      sym = arg unless arg.is_a? Numeric
    end
    [answer, sym]
  end
end
