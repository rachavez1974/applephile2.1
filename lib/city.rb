class City
  attr_accessor :name, :state, :city_url
  attr_reader :items

  @@all = []

  def initialize(city_attributes)
    city_attributes.each {|key, value| self.send(("#{key}="), value)}
    @items = []
    @@all << self
  end

  def add_item(item)
    item.city = self
    @items << item
    item
  end

  def get_apple_prods_by_price(set_price)
    @items.select { |item| item.price.to_i >= set_price.to_i }
  end
  
end
