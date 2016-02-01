module NeuralNFL
  class Network
    attr_accessor :hidden_layer, :output_layer

    def initialize(input_count, hidden_count, output_count, learning_rate)
      @layers = [
          Array.new(hidden_count, Vector.elements(Array.new(input_count, rand(-1.0..1.0)))),
          Array.new(output_count, Vector.elements(Array.new(hidden_count, rand(-1.0..1.0))))
      ]
      @learning_rate = learning_rate
    end

    def evaluate(inputs)
      @layers.reduce(Vector.elements(inputs)) do |input, layer|
        Vector.elements(layer.map { |weights| weights.inner_product(input) })
      end
    end

    def train(inputs, expected)
      inputs = Vector.elements(inputs)
      hidden_outs = Vector.elements(@layers.first.map { |weights| weights.inner_product(inputs) })
      output_outs = Vector.elements(@layers.last.map { |weights| weights.inner_product(hidden_outs) })
      output_deltas = get_output_deltas(expected, output_outs)
      hidden_deltas = get_hidden_deltas(hidden_outs, @layers.last, output_deltas)
      update_output_weights!(hidden_outs, output_deltas)
      update_hidden_weights!(inputs, hidden_deltas)
    end

    def get_output_deltas(expected, output)
      expected.zip(output.to_a).map do |expect, out|
        (expect - out) * out * (1 - out)
      end
    end

    def get_hidden_deltas(hidden_outs, output_nodes, output_deltas)
      @layers.first.each_index.map do |node_index|
        error = output_nodes.zip(output_deltas).map { |weights, delta| weights[node_index] * delta }.reduce(:+)
        error * hidden_outs[node_index] * (1 - hidden_outs[node_index])
      end
    end

    def update_output_weights!(inputs, deltas)
      @layers.last.each_with_index do |weights, node_index|
        weights.each_with_index do |weight, weight_index|
          weight - (@learning_rate * inputs[weight_index] * deltas[node_index])
        end
      end
    end

    def update_hidden_weights!(inputs, deltas)
      @layers.first.each_with_index do |weights, node_index|
        weights.each_with_index do |weight, weight_index|
          weight - (@learning_rate * inputs[weight_index] * deltas[node_index])
        end
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
