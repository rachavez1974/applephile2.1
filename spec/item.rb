require "spec_helper"
require_relative "../lib/item.rb"


RSpec.describe "Item" do
  let!(:cl_first) {CraigsList.new()}
  let!(:city_url) {cl_first.return_city_link("New Mexico", "clovis") }
  let!(:phone_hash) {cl_first.scrape_by_city_url(city_url) }
  let!(:first_phone) {phone_hash.first }

  describe "#initialize" do

    it "accepts a hash of attributes to assign" do
      item_one = Item.new(first_phone)

      item_one_city = item_one.instance_variable_get(:@city)
      item_one_price = item_one.instance_variable_get(:@price)
      item_one_description = item_one.instance_variable_get(:@description)
      item_one_url = item_one.instance_variable_get(:@url)
    
      expect(item_one_city).to eq(nil)
      expect(item_one_price).to eq(first_phone[:price])
      expect(item_one_description).to eq(first_phone[:description])
      expect(item_one_url).to eq(first_phone[:url])
    
    end
  end

end