module NeuralNFL
  class Neuron
    attr_accessor :weights, :delta, :inputs, :out

    def initialize(weights)
      @weights = weights
    end

    def evaluate(inputs)
      @inputs = inputs
      @out = sigmoid(weighted_sum(inputs))
    end

    def weighted_sum(inputs)
      weights.zip(inputs).map { |x, y| x * y }.reduce(:+)
    end

    def sigmoid(x)
      1 / (1 + Math.exp(-1 * x))
    end
  end
end
