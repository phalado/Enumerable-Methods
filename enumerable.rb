# frozen_string_literal: true

module Enumerable
  def my_each
    i = 0
    while i < length
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    i = 0
    while i < length
      yield(i, self[i])
      i += 1
    end
  end

  def my_select
    new_array = []
    my_each do |x|
      new_array << x if yield(x)
    end
    new_array
  end

  def my_all?
    answer = true
    my_each do |x|
      answer = false unless yield(x)
    end
    answer
  end

  def my_any?
    answer = false
    my_each do |x|
      answer = true if yield(x)
    end
    answer
  end

  def my_none?
    answer = true
    my_each do |x|
      answer = false if yield(x)
    end
    answer
  end

  def my_count
    counter = 0
    my_each do |x|
      counter += 1 if yield(x)
    end
    counter
  end

  def my_map(param = nil)
    new_array = []
    if block_given?
      my_each do |x|
        new_array << yield(x)
      end
    else
      my_each do |x|
        new_array << param.call(x)
      end
    end
    new_array
  end

  def my_inject
    answer = yield(0, 1).zero? ? 1 : 0
    my_each do |x|
      answer = yield(answer, x)
    end
    answer
  end

  def multiply_els
    my_inject { |x, y| x * y }
  end
end

# arr = [5, 7, 3, 5, 8, 9]
# arr.my_each { |x| puts x }
# arr.my_each_with_index { |x, y| puts "#{y} - #{x}" }
# puts arr.my_select { |x| x > 5 }
# puts arr.my_all? { |x| x > 5 }
# puts arr.my_all? { |x| x > 2 }
# puts arr.my_any? { |x| x > 5 }
# puts arr.my_any? { |x| x < 2 }
# puts arr.my_none? { |x| x > 5 }
# puts arr.my_none? { |x| x < 2 }
# puts arr.my_count { |x| x > 5 }
# puts arr.my_map { |x| x ** 2 }
# puts arr.my_map proc { |x| x ** 3 }
# puts arr.my_inject { |x, y| x + y }
# puts arr.multiply_els
