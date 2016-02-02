module NeuralNFL
  class Network
    attr_accessor :hidden_layer, :output_layer

    #TODO bias
    #TODO momentum
    #TODO dropout
    #TODO multiple hidden layers

    def initialize(input_count, hidden_count, output_count, learning_rate)
      @layers = [
          Array.new(hidden_count, Vector.elements(Array.new(input_count, rand(-1.0..1.0)))),
          Array.new(output_count, Vector.elements(Array.new(hidden_count, rand(-1.0..1.0))))
      ]
      @learning_rate = learning_rate
      @activate = lambda { |x| 1 / (1 + Math.exp(-1 * x )) }
      @activate_prime = lambda { |x| x * (1 - x) }
    end

    #TODO dry this
    def evaluate(inputs)
      @layers.reduce(Vector.elements(inputs)) do |input, layer|
        Vector.elements(layer.map { |node| @activate.call(node.inner_product(input)) })
      end
    end

    def train(inputs, expected)
      inputs = Vector.elements(inputs)
      #TODO dry this
      hidden_outs = Vector.elements(@layers.first.map { |node| @activate.call(node.inner_product(inputs)) })
      output_outs = Vector.elements(@layers.last.map { |node| @activate.call(node.inner_product(hidden_outs)) })
      output_deltas = get_output_deltas(expected, output_outs)
      hidden_deltas = get_hidden_deltas(hidden_outs, @layers.last, output_deltas)
      update_output_weights!(hidden_outs, output_deltas)
      update_hidden_weights!(inputs, hidden_deltas)
    end

    def get_output_deltas(expected, output)
      expected.zip(output.to_a).map do |expect, out|
        (expect - out) * @activate_prime.call(out)
      end
    end

    def get_hidden_deltas(hidden_outs, output_nodes, output_deltas)
      @layers.first.each_index.map do |node_index|
        error = output_nodes.zip(output_deltas).map { |weights, delta| weights[node_index] * delta }.reduce(:+)
        error * @activate_prime.call(hidden_outs[node_index])
      end
    end

    #TODO dry this
    def update_output_weights!(inputs, deltas)
      @layers[1] = @layers.last.each_with_index.map do |weights, node_index|
        weights = weights.each_with_index.map do |weight, weight_index|
          weight + (@learning_rate * inputs[weight_index] * deltas[node_index])
        end
        Vector.elements(weights)
      end
    end

    def update_hidden_weights!(inputs, deltas)
      @layers[0] = @layers.first.each_with_index.map do |weights, node_index|
        weights = weights.each_with_index.map do |weight, weight_index|
          weight + (@learning_rate * inputs[weight_index] * deltas[node_index])
        end
        Vector.elements(weights)
      end
    end

    def serialize
      YAML.dump(self)
    end

    def self.from_serialized(dump)
      YAML.load(dump)
    end
  end
end
