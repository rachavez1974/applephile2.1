require "spec_helper"
require_relative "../lib/craigslist.rb"


RSpec.describe "CraigsList" do                  
  let!(:cl_first) {CraigsList.new()}
  let!(:state_names) { 
                  ['Alabama','Alaska','Arizona','Arkansas','California',
                  'Colorado','Connecticut','Delaware','District of Columbia','Florida',
                  'Georgia','Hawaii',
                  'Idaho','Illinois','Indiana','Iowa','Kansas','Kentucky','Louisiana',
                  'Maine','Marshall Islands','Maryland','Massachusetts','Michigan',
                  'Minnesota','Mississippi','Missouri','Montana','Nebraska','Nevada',
                  'New Hampshire','New Jersey','New Mexico','New York','North Carolina',
                  'North Dakota','Ohio','Oklahoma','Oregon',
                  'Palau','Pennsylvania','Rhode Island','South Carolina',
                  'South Dakota','Tennessee','Texas','Utah','Vermont',
                  'Virginia','Washington','West Virginia','Wisconsin','Wyoming']
                }

  let!(:cities_and_links_data) { [{"auburn" =>"https://auburn.craigslist.org/"},
                            {"fort collins"=>"https://fortcollins.craigslist.org/"},
                            {"macon"=>"https://macon.craigslist.org/"}] } 

  let!(:states_cities_links_data){  {:Montana => [{"billings"=>"https://billings.craigslist.org/"},
                                                  {"bozeman"=> "https://bozeman.craigslist.org/"},
                                                  {"butte"=>"https://butte.craigslist.org/"}],
                                    :Minnesota => [{"bemidji"=>"https://bemidji.craigslist.org/"},
                                                  {"brainerd"=>"https://brainerd.craigslist.org/"},
                                                  {"duluth"=>"https://duluth.craigslist.org/"}],
                                   :"New Mexico" =>[{"albuquerque"=>"https://albuquerque.craigslist.org/"},
                                                  {"clovis"=>"https://clovis.craigslist.org/"},
                                                  {"farmington"=>"https://farmington.craigslist.org/"}]
                                    }
                                 }  
  let!(:p_hash) { { :url=>"https://amarillo.craigslist.org/mob/d/amarillo-iphone-8-plus-256gb-gold-unlock/6906496735.html", 
                    :price=>"650", 
                    :description=>"Iphone 8 plus 256gb gold (unlock)"}
                }  

  def choose_random_state
    state_names[rand(0..state_names.length - 1)]
  end

  after(:each) do 
    CraigsList.class_variable_set(:@@all, [])
  end
  describe "#initialize" do
    it "it has default values, and visits the about page of craiglist to collect html" do
      cl_second = CraigsList.new()

      cl_second_site = cl_second.instance_variable_get(:@site_url)
      cl_second_doc = cl_second.instance_variable_get(:@doc)
    
      expect(cl_second_site).to eq("https://www.craigslist.org/about/sites")
      expect(cl_second_doc).to eq(cl_second.doc)
    
    end
  end

  describe "#get_states_names" do
    it "it uses the doc getter to access html docucment, and collects all the states names of the U.S." do
      state_names = cl_first.get_states_names
      expect(state_names).to include(choose_random_state)
    end
  end

  describe "#cities_and_links" do
    it "it uses html scraped to collect cities and their links, test for three states." do
    links = cl_first.send(:cities_and_links)
    expect(links[0][0]).to include(cities_and_links_data[0])
    expect(links[5][4]).to include(cities_and_links_data[1])
    expect(links[10][6]).to include(cities_and_links_data[2])      
    end
  end

  describe "#states_cities_links" do
    it "it returns a hash at first level and hash has states as keys, then this hash points to array of hashes
    every hash inside this array has a key for every city belonging to that state, and the value is the link to that city" do
    links = cl_first.send(:states_cities_links)
    expect(links[:Montana][0]).to include(states_cities_links_data[:Montana][0])
    expect(links[:Montana][1]).to include(states_cities_links_data[:Montana][1])
    expect(links[:Montana][2]).to include(states_cities_links_data[:Montana][2])
    expect(links[:Minnesota][0]).to include(states_cities_links_data[:Minnesota][0])
    expect(links[:Minnesota][1]).to include(states_cities_links_data[:Minnesota][1])
    expect(links[:Minnesota][2]).to include(states_cities_links_data[:Minnesota][2])
    expect(links[:"New Mexico"][0]).to include(states_cities_links_data[:"New Mexico"][0])
    expect(links[:"New Mexico"][1]).to include(states_cities_links_data[:"New Mexico"][1])
    expect(links[:"New Mexico"][2]).to include(states_cities_links_data[:"New Mexico"][2])
    end
  end

  describe "#return_city_link" do
    it "it returns the link of a specific city when sent a state name or city" do
      city_url = cl_first.return_city_link("New Mexico", "albuquerque")
      expect(city_url).to eq("https://albuquerque.craigslist.org/")
    end
  end

  describe "#get_state_cities" do
    it "it returns an array of cities belonging to that state" do
      state_cities = cl_first.get_state_cities("Minnesota")
      expect(state_cities).to include("bemidji")
      expect(state_cities).to include("brainerd")
      expect(state_cities).to include("duluth")
    end
  end

  describe "#scrape_by_city_url" do
    it "it returns an array of hashes, each hash has info about a particular phone for ex. description,
        price, and link where user can check it out online" do
        city_url = cl_first.return_city_link("New Mexico", "clovis") 
        phone_hash = cl_first.scrape_by_city_url(city_url)
        first_phone = phone_hash.first
        expect(first_phone).to eq(p_hash)
    end
  end


end


