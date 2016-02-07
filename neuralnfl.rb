# Neural NFL
# Robert Scott Reis 2016

require 'weka'
require 'sinatra/base'
require 'haml'

PLAYS_TYPES = ['Run', 'Pass', 'Field goal', 'Fake field goal', 'Punt', 'Fake punt', 'Kneel', 'Spike']

instances = Weka::Core::Instances.from_arff('nfl.arff')
instances.class_attribute = :type
$classifier = Weka::Classifiers::Bayes::BayesNet.new
$classifier.train_with_instances(instances)

class NeuralNFL < Sinatra::Base
  get '/' do
    haml :index
  end

  post '/' do
    time = (60.0 - (params['quarter'].to_i * 15.0) + params['time'].to_i) / 60.0
    down = (params['down'].to_i / 4.0).to_s.to_sym
    to_first = params['to-first'].to_i / 100.0
    to_goal = params['to-goal'].to_i / 100.0
    score_diff = params['off-score'].to_i - params['def-score'].to_i
    @results = $classifier.distribution_for [time, down, to_first, to_goal, score_diff, '?']
    haml :index
  end

  run! if app_file == $0
end
