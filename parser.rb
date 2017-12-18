require 'net/http'
require 'json'
require 'singleton'

class DestinationParserError < StandardError 

end

class GoogleApiUrl
     include Singleton
     attr_reader :url, :json, :key
     attr_accessor :origins, :destinations
     def initialize(url='https://maps.googleapis.com/maps/api/distancematrix/', 
                    key='AIzaSyCY05U4IKsK-Wkb38WwyZOKPgOH6s8j_JI', 
                    json=true, 
                    origins='', 
                    destinations='' )
       @url = url
       @json ='json?' if json == true
       @origins = origins
       @destinations = destinations  
       @key = key
     end
     
end


class DestinationParser
  
    def distance_between_cities(origin, destination)
        google_api_url = GoogleApiUrl.instance
        begin
            raise DestinationParserError, 'Origin must be filled' unless origin.is_a? String
            raise DestinationParserError, 'Destination to must be filled' unless destination.is_a? String
            google_api_url.origins = origin
            google_api_url.destinations = destination
            uri = URI(google_api_url.url + google_api_url.json + '&origins=' + google_api_url.origins +
                       '&destinations=' + google_api_url.destinations + '&key' +
                                          google_api_url.key )                          
            parsed_data = JSON.parse(Net::HTTP.get(uri))  
            raise DestinationParserError, 'Please provide correct origin' if parsed_data['origin_addresses'][0].empty?
            raise DestinationParserError, 'Please provide correct destination' if parsed_data['destination_addresses'][0].empty?
            distance = parsed_data['rows'][0]['elements'][0]['distance']['text'] 
            time = parsed_data['rows'][0]['elements'][0]['duration']['text']
            return distance + ', ' + time

            rescue DestinationParserError => e
                p e.message  
            rescue DestinationParserError => e 
                p e.message
        end
    end
end
