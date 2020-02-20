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
    # @location = params["q"]
    # @geocoder_results = Geocoder.search(@location)
    # @lat_long = @geocoder_results.first.coordinates # => [lat, long] array

    @results = Geocoder.search(params["q"])
    #@geocoder_results = Geocoder.search(@results)
    @lat_long = @results.first.coordinates # => [lat, long]
    "#{@lat_long[0]} #{@lat_long[1]}"
    url = 
    # url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=33043a374d84404e9df3c50b2cfac350"
    # news = HTTParty.get(url).parsed_response.to_hash
end

get "/" do
    #show a view that asks user for a location
    view "ask"
end