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
        error = output_nodes.zip(output_deltas).map { |n, delta| delta * n.weights[i] }.reduce(:+)
        node.out * (1 - node.out) * error
      end
    end

    def update_weights!(deltas, learning_rate)
      nodes.zip(deltas).each do |node, delta|
        node.weights = node.weights.zip(node.inputs).map do |weight, input|
          weight - (learning_rate * delta * input)
        end
      end
    end
  end
end
