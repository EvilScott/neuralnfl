# Neural NFL
# Robert Scott Reis 2016

require_relative 'neural_nfl/network'
require_relative 'neural_nfl/layer'
require_relative 'neural_nfl/neuron'

module NeuralNFL
  class << self
    def create(input_count, output_count)
      hidden_count = (input_count + output_count) / 2
      NeuralNFL::Network.new(input_count, hidden_count, output_count, 0.25)
    end
  end
end
