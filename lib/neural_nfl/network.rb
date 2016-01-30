module NeuralNFL
  class Network
    attr_accessor :hidden_layer, :output_layer

    def initialize(input_count, hidden_count, output_count, learning_rate)
      @hidden_layer = Layer.new(input_count, hidden_count)
      @output_layer = Layer.new(hidden_count, output_count)
      @learning_rate = learning_rate
    end

    def eval!(inputs)
      [@hidden_layer, @output_layer].reduce(inputs) { |ins, layer| layer.eval!(ins) }
    end

    def train!(inputs, expected)
      # TODO refactor into smaller methods for testing

      # feed forward
      eval!(inputs)

      # backprop
      @output_layer.nodes.each_with_index do |node, i|
        error = expected[i] - node.out
        node.delta = node.out * (1 - node.out) * error
      end
      @hidden_layer.nodes.each_with_index do |node, i|
        error = @output_layer.nodes.map { |n| n.delta * n.weights[i] }.reduce(:+)
        node.delta = node.out * (1 - node.out) * error
      end

      # update weights
      @output_layer.nodes.each do |node|
        node.weights = node.weights.each_with_index.map do |weight, i|
          weight - (@learning_rate * node.delta * node.inputs[i])
        end
      end
      @hidden_layer.nodes.each do |node|
        node.weights = node.weights.each_with_index.map do |weight, i|
          weight - (@learning_rate * node.delta * inputs[i])
        end
      end

      # TODO return some kind of error measurement?
    end

    def serialize
      # TODO serialize weights and layer counts
    end

    def self.from_serialized(serialized_network)
      # TODO create a new network from serialized network
    end
  end
end
