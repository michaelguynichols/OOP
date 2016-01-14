# Q1
class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

oracle = Oracle.new
puts oracle.predict_the_future

# -----

# Q2
# It will pull the choices from the current class (subclass).

# -----

# Q3
# Use .ancestors on the class.

# -----

# Q4
# Add an attr-accessor, giving read-write capabilities.

# -----

# Q5
# By the @'s.

# -----

# Q6
# Self signifies a class method.

# -----

# Q7
# @@ is a class variable, shared by all instances of the class. You could instantiate an
# object of the class and test its shared behavior.

# -----

# Q8
# < Game

# -----

# Q9
# It would overwrite the play from the parent class, because Ruby looks at the current class first.

# -----

# Q10
# Mainly, a more logical pattern for programming, grouping things into coherent clusters.
# It separates the concerns of different objects, hides functionality so you don't need to
# know everything about what the class does as long as it is clear.
# It also puts things into a human-style language.

# -----
