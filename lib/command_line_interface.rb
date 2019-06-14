class CLI
  INTRO_MESSAGE = "WELCOME TO CRAIGSLIST SCRAPPER!"

  def run
    @scrape = CraigsList.new
    puts INTRO_MESSAGE
    choice = ""
    while choice != "exit"      
      choice = display_main_menu
      if choice == "scrape"
        get_menu_input
        create_items_from_array(scrape_phones())
        grab_phones
      end
    end
  end



  def display_main_menu
    stars = "************************".colorize(:yellow)
    puts "#{stars} MAIN MENU #{stars}" 
    puts "Enter \"scrape\" to scrape.".colorize(:blue)
    puts "Enter \"exit\" to end program.".colorize(:yellow)
    puts "What would you like to do?".colorize(:blue)
    gets.chomp
  end


  def get_choice
    puts "Enter number to see link phone on browser.".colorize(:cyan)
    puts "next for more phones".colorize(:green)
    puts "Or enter exit to re-scrape.".colorize(:blue)
    gets.chomp
  end

  
  
end