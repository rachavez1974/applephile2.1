class City
  attr_accessor :name, :state, :city_url
  attr_reader :items

  @@all = []

  def initialize(city_attributes)
    city_attributes.each {|key, value| self.send(("#{key}="), value)}
    @items = []
    @@all << self
  end

  
end
