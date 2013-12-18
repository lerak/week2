class Animal
	attr_accessor :name, :age 

	def initialize(name, age)
		@name = name
		@age = age 
	end 

end
module Swimable
	def swim
		"#{name} is swimming"
	end
end
class Dog < Animal
include Swimable
	def barking
      puts "#{name} is barking"
	end

	
end

class Cat < Animal

	
end 
pasha = Dog.new('pasha',5)

kitty = Cat.new('kitty', 2)

puts kitty.age
puts "#{pasha.name} is #{pasha.age} jaar oud !"
pasha.barking

puts pasha.swim

