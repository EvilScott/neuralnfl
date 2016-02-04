# Neural NFL
# Robert Scott Reis 2016

require_relative 'neural_nfl/network'
require 'matrix'
require 'yaml'
require 'csv'

module NeuralNFL
  class << self
    def network
      unless @network
        training_data = CSV.read('data/testdata.csv').map { |row| row.map(&:to_f) }
        @network = NeuralNFL::Network.new(5, 7, 8, 0.25)
        training_data.each { |datum| @network.train!(datum.first(5), datum.last(8)) }
      end
      @network
    end
  end
end
