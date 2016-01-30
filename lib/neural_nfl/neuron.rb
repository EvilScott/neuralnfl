module NeuralNFL
  class Neuron
    attr_accessor :weights, :delta, :inputs, :out

    def initialize(weights)
      @weights = weights
    end

    def eval!(inputs)
      @inputs = inputs
      @out = sigmoid(weighted_sum(inputs))
    end

    def weighted_sum(inputs)
      weights.zip(inputs).inject(0) { |sum, x| sum + x.inject(:*) }
    end

    def sigmoid(x)
      1 / (1 + Math.exp(-1 * x))
    end
  end
end
