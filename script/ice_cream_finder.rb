require 'nokogiri'
require 'addressable/uri'
require 'rest-client'
require 'json'


puts "What is your current address?"
user_address = gets.chomp.split(" ").join("+")

input_address_url = Addressable::URI.new(
:scheme => "http",
:host => "maps.googleapis.com",
:path => "/maps/api/geocode/json",
:query_values => {:address => "#{user_address}", :sensor => false}
).to_s


response = RestClient.get(input_address_url)
puts location_hash = response.first#["results"]# .first["geometry"]["location"]
#http://maps.googleapis.com/maps/api/geocode/output?address=user_address
#gives address to google Geocoding
#gets lat, lon


#gives lat,lon to google Places search API
# returns list of business and their addresses matching the keyword


#pick first business's address
# use google Directions API to find directions
