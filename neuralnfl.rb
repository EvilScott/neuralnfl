# Neural NFL
# Robert Scott Reis 2016

require 'brainy'
require 'sinatra/base'
require 'haml'
require 'matrix'
require 'yaml'
require 'csv'

PLAYS_TYPES = ['Run', 'Pass', 'Field goal', 'Fake field goal', 'Punt', 'Fake punt', 'Kneel', 'Spike']

$net = Brainy::Network.from_serialized(File.open('data/network.yml'))

class NeuralNFL < Sinatra::Base
  get '/' do
    haml :index
  end

  post '/' do
    time = (60.0 - (params['quarter'].to_i * 15.0) + params['time'].to_i) / 60.0
    down = params['down'].to_i / 4.0
    to_first = params['to-first'].to_i / 100.0
    to_goal = params['to-goal'].to_i / 100.0
    score_diff = params['off-score'].to_i - params['def-score'].to_i
    @inputs = [time, down, to_first, to_goal, score_diff]
    @results = Hash[PLAYS_TYPES.zip($net.evaluate(@inputs).to_a.map { |x| x.round(6) })]
    haml :index
  end

  run! if app_file == $0
end
