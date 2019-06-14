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

  def get_state_cities(state_name)
    #it returns an array of cities belonging to a particular state
    #1. find the state first.
    #2. then collect the state's city array, return a flatten array so only cities can be used
    #to be displayed in CLI
    state_cities_array = []
    states_cities_links.each do |states, cities_links|
      if states.to_s == state_name 
        #collect only cities
        state_cities_array = cities_links.collect { |city| city.keys }
        break
      end
    end
    state_cities_array.flatten!  

  end

  def return_city_link(state, city)
    #it returns the link of a particular city
    #1. find state hash
    #2. find the city
    #3. get city's link
    city_url = ""
    states_cities_links.find do |key, value|  
      if key.to_s == state
        value.find do |city_hash|
           if city_hash.has_key?(city) 
            city_url = city_hash[city]
           end
         end
      end
    end
    city_url
  end

  def scrape_by_city_url(city_url)
    items_array_of_hashes = []
    #1. returns an array of hashes for every link (phone found) for a particular scrape criteria
    #2. build site link with searching criteria phones with pic, new, os 
    #3. grab all phones that meet this search criteria.
    #4. traverse the collection, and grab each needed attribute one by one.
    #5. build hash, and save it to array.
    #6. return hash
    city_url = city_url + "search/moa?hasPic=1&condition=10&mobile_os=2"
    city_doc = Nokogiri::HTML(open(city_url))
    grab_all_phones = city_doc.css(".result-info")
      grab_all_phones.each do |phones|
         phone_url = phones.css("a")[0]["href"]
         phone_price = phones.css(".result-price").text.split("$")[1]
         phone_description = phones.css("a").text.split("\n")[0]
         items_array_of_hashes.push({:url => phone_url,
                                     :price => phone_price,
                                     :description => phone_description})
      end
      items_array_of_hashes
  end


  private

  def cities_and_links
    #it returns a two dimensional array of cities, with their links as a hash by the state
    # [[{"citya" => linka}, {"cityb" => linkb}, {"cityc" => linkc}], [{"cityz" => linkz}]]

    two_dimension_city = []
    doc.css(".colmask").first.css("ul").each do |city| 
      #collect returns [{"city1" => link1}, {city2 => link2}]
      #collect removes "/" and unnecessary spaces from cities
      two_dimension_city.push(city.css("li a").collect { |city| { city.text.split("/")[0].strip  => city["href"] }})
    end
    two_dimension_city 
  end

  def states_cities_links
    #returns a array of hashes with keys equal to states, and values
    #equal to an array of cities and their respective links
    #{ :state1 => [{"city1" => link1}, {city2 => link2}, {city3 => link3}],
     #  :state2 => [{}]}

    states_cities_links_hash = {}
    #proceed by states, make hash, then push into array
    #cities index implicitly starts from the first state
    get_states_names.each_with_index do |state, index|
      states_cities_links_hash[state.to_sym] = cities_and_links[index]
    end
    states_cities_links_hash
  end


end