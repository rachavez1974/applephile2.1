require 'nokogiri'
require 'open-uri'
require 'pry'

class CraigsList
  attr_accessor :site_url, :doc
  
  def initialize()
    @site_url = "https://www.craigslist.org/about/sites"
    @doc = Nokogiri::HTML(open(@site_url))  
  end

  def get_states_names
    #it returns an array of states of the U.S., CLI will use to display them
    doc.css(".colmask").first.css("h4").collect { |st| st.text}  
  end

end