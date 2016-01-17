module NeuralNFL
  class Neuron
    attr_accessor :weights, :bias

    def initialize(weights, bias)
      @weights, @bias = weights, bias
    end

    def eval(inputs)
      sigmoid(weighted_sum(inputs))
    end

    def weighted_sum(inputs)
      weights.zip(inputs).inject(0) { |sum, x| sum + x.inject(:*) } + bias
    end

    def sigmoid(x)
      1 / (1 + Math.exp(-1 * x))
    end

    def sigmoid_prime(x)
      sigmoid(x) * (1 - sigmoid(x))
    end
  end
end
