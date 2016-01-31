module NeuralNFL
  class Layer
    attr_accessor :nodes

    def initialize(input_count, node_count)
      @nodes = Array.new(node_count, random_node(input_count))
    end

    def random_node(input_count)
      Neuron.new(Array.new(input_count, Random.new.rand(2.0) - 1))
    end

    def eval(inputs)
      @nodes.map { |node| node.eval(inputs) }
    end

    def output_deltas(expected)
      nodes.zip(expected).map do |node, exp|
        node.out * (1 - node.out) * (exp - node.out)
      end
    end

    def hidden_deltas(output_nodes)
      nodes.each_with_index.map do |node, i|
        error = output_nodes.map { |n| n.delta * n.weights[i] }.reduce(:+)
        node.out * (1 - node.out) * error
      end
    end

    def update_weights!(deltas, learning_rate)
      nodes.each do |node|
        node.weights = node.weights.each_with_index.map do |weight, i|
          weight - (learning_rate * deltas[i] * node.inputs[i])
        end
      end
    end
  end
end
