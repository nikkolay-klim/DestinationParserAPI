require 'sinatra'
require './parser.rb'



get '/distance/from/*/to/*' do
    d = DestinationParser.new
    d.distance_between_cities(params['splat'][0],params['splat'][1])
end