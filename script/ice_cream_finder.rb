require 'nokogiri'
require 'addressable/uri'
require 'rest-client'
require 'json'
# require 'launchy'


puts "What is your current address?"
user_address = "160 Folsom Street, San Francisco, Ca".split(" ").join("+")

input_address_url = Addressable::URI.new(
:scheme => "http",
:host => "maps.googleapis.com",
:path => "/maps/api/geocode/json",
:query_values => {:address => "#{user_address}", :sensor => false}
).to_s


response = RestClient.get(input_address_url)
response_hash = JSON.parse(response)
location_hash = response_hash["results"].first["geometry"]["location"]
lat = location_hash["lat"]
lng = location_hash['lng']

api_key = "AIzaSyDdeo1KFEQGGl3W8pclEM39mE-AJ6q8bF8"

input_search_url = Addressable::URI.new(
:scheme => "https",
:host => "maps.googleapis.com",
:path => "/maps/api/place/nearbysearch/json",
:query_values => {
  :location => "#{lat},#{lng}",
  :keyword => "ice cream",
  :sensor => false,
  :radius => 500,
  :key => "#{api_key}"}).to_s

input_search_url

search_response = RestClient.get(input_search_url)
search_response_hash = JSON.parse(search_response)
result_address = search_response_hash["results"].first["geometry"]["location"]
name_of_location = search_response_hash["results"].first["name"]

destination_lat = result_address['lat']
destination_lng = result_address['lng']

input_destination_url = Addressable::URI.new(
:scheme => "https",
:host => "maps.googleapis.com",
:path => "/maps/api/directions/json",
:query_values => {
  :origin => "#{lat},#{lng}",
  :destination => "#{destination_lat},#{destination_lng}",
  :sensor => false}).to_s

destination_response = RestClient.get(input_destination_url)
destination_response_hash = JSON.parse(destination_response)

steps = destination_response_hash['routes'].first['legs'].first['steps']
direction_array = []

steps.each do |step|
  step.each do |key, value|
    if key == "html_instructions"
      direction_array << value
    end
  end
end

puts "#{name_of_location}"
direction_array.each do |step|
  parsed_html = Nokogiri::HTML(step)
  puts parsed_html.text
end

# Launchy.open(input_destination_url)

  # http://maps.googleapis.com/maps/api/directions/json?origin=Toronto&destination=Montreal&sensor=false

#pick first business's address
# use google Directions API to find directions
