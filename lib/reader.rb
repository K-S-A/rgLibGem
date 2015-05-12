module RgLibGem
  class Reader < Library
  attr_reader :name, :email, :city, :street, :house

    def initialize(name, *args)
      @name = name
      @email, @city, @street, @house = args
      instance_variables.each do |var|
        instance_variable_get(var).nil? ? instance_variable_set(var, "n/a") : instance_variable_get(var).strip!
        var == :@email ? instance_variable_get(var).downcase! : instance_variable_get(var).capitalize!
      end
    end
  end
end
