module NeuralNFL
  class Layer
    attr_accessor :nodes

    def initialize(input_count, node_count)
      @nodes = Array.new(node_count, random_node(input_count))
    end

    def random_node(input_count)
      Neuron.new(Array.new(input_count, Random.new.rand(2.0) - 1))
    end

    def evaluate(inputs)
      @nodes.map { |node| node.evaluate(inputs) }
    end

    def output_deltas(expected)
      nodes.zip(expected).map do |node, exp|
        node.out * (1 - node.out) * (exp - node.out)
      end
    end

    def hidden_deltas(output_nodes, output_deltas)
      nodes.each_with_index.map do |node, i|
        error = output_nodes.each_with_index.map { |n, j| output_deltas[j] * n.weights[i] }.reduce(:+)
        node.out * (1 - node.out) * error
      end
    end

    def update_weights!(deltas, learning_rate)
      nodes.each_with_index do |node, i|
        node.weights = node.weights.each_with_index.map do |weight, j|
          weight - (learning_rate * deltas[i] * node.inputs[j])
        end
      end
    end
  end
end
