# Q1
# attr_reader creates an automatic balance method.

# -----

# Q2
# No write access.

# -----

# Q3


# -----

# Q4
class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

# -----

# Q5
class KrispyKreme
  attr_reader :filling_type, :glazing
  def initialize(filling_type, glazing)
    @filling_type = filling_type
    @glazing = glazing
  end

  def to_s
    filler = 'with'
    first = 'Plain'
    if !glazing
      filler = ''
    end

    if filling_type
      first = filling_type
    end
    "#{first} #{filler} #{glazing}"
  end
end

donut1 = KrispyKreme.new(nil, nil)
donut2 = KrispyKreme.new("Vanilla", nil)
donut3 = KrispyKreme.new(nil, "sugar")
donut4 = KrispyKreme.new(nil, "chocolate sprinkles")
donut5 = KrispyKreme.new("Custard", "icing")

puts donut1

puts donut2

puts donut3

puts donut4

puts donut5
# -----

# Q6
# No difference.

# -----

# Q7
# self.information

# -----

# Q8


# -----

# Q9


# -----

# Q10


# -----
