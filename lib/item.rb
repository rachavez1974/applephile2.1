class Item
  attr_accessor :city, :price, :description, :url
  
  def initialize(item_attributes)
    item_attributes.each {|key, value| self.send(("#{key}="), value)}
  end

end