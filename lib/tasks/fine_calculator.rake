namespace :fine_calculator do
  desc "Runs every n hours depending on Heroku's scheduler setup
        * Calculate blown shifts Sunday at midnight
        * When you blow a shift you should be subtracted double 
                the hrs that the shift (eg. 2 hrs of pots = -4 hrs if blown)
        * Every fining date you are fined the fining 
                rate*hrs down and your hrs are reset to 0"
  task :start do
    puts "Making the attempt to ping the dyno"

    if ENV['URL']
      puts "Sending ping"

      uri = URI(ENV['URL'])
      Net::HTTP.get_response(uri)

      puts "success..."
    end
  end
end