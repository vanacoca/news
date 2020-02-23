require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "3bb1b33e89ef956ed282a1a3c66e4827"

get "/news" do
    #do everything else

    @results = Geocoder.search(params["q"])
    @location = params["q"]
    @lat_long = @results.first.coordinates # => [lat, long]
  
    @forecast = ForecastIO.forecast(@lat_long[0], @lat_long[1]).to_hash 
    @current_temperature = @forecast["currently"]["temperature"]
    @conditions = @forecast["currently"]["summary"]
    "In #{@location}, it is currently #{@current_temperature} and #{@conditions}"
    
    day_hightemp = []
    day_condition = []
    for day in @forecast["daily"]["data"]
        day_hightemp << "#{day["temperatureHigh"]}"
        day_condition << "#{day["summary"]}"
    "A high temperature of #{day["temperatureHigh"]} and #{day["summary"]}."
    end
    @listtemp = day_hightemp
    @listcondition = day_condition
    #@day = Time.at(day["time"]).strftime("%a")
    
    @url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=33043a374d84404e9df3c50b2cfac350"
    @news = HTTParty.get(@url).parsed_response.to_hash
    pp @news

    headline_url = []
    for headlines in @news["articles"]
        headline_url << "#{headlines["url"]}"
    end
    @listurl = headline_url

    headline_title = []
    for headlinetitles in @news["articles"]
        headline_title << "#{headlinetitles["title"]}"
    end
    @listtitles = headline_title


    # news is now a Hash you can pretty print (pp) and parse for your output
 view "news"
end

get "/" do
    #show a view that asks user for a location
    view "ask"
end