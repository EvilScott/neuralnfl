module NeuralNFL
  class Layer
    attr_accessor :nodes

    def initialize(input_count, node_count)
      @nodes = Array.new(node_count, random_node(input_count))
    end

    def random_node(input_count)
      rand = Random.new
      Neuron.new(Array.new(input_count, rand.rand(2.0) - 1), rand.rand(2.0) - 1)
    end

    def eval(inputs)
      @nodes.map { |node| node.eval(inputs) }
    end
  end
end
