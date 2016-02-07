# Neural NFL
# Robert Scott Reis 2016

require 'brainy'
require 'sinatra/base'
require 'haml'
require 'matrix'
require 'yaml'
require 'csv'

$net = Brainy::Network.from_serialized('data/network.yml')

class NeuralNFL < Sinatra::Base
  get '/' do
    haml :index
  end

  post '/play' do
    @results = $net.evaluate([]).inspect
    haml :index
  end

  run! if app_file == $0
end
