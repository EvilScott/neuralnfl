module NeuralNFL
  class Network
    attr_accessor :hidden_layer, :output_layer

    def initialize(input_count, hidden_count, output_count, learning_rate)
      @hidden_layer = Layer.new(input_count, hidden_count)
      @output_layer = Layer.new(hidden_count, output_count)
      @learning_rate = learning_rate
    end

    def evaluate(inputs)
      [@hidden_layer, @output_layer].reduce(inputs) { |ins, layer| layer.evaluate(ins) }
    end

    def train!(inputs, expected)
      outputs = evaluate(inputs)
      output_deltas = @output_layer.output_deltas(expected)
      hidden_deltas = @hidden_layer.hidden_deltas(@output_layer.nodes, output_deltas)
      @output_layer.update_weights!(output_deltas, @learning_rate)
      @hidden_layer.update_weights!(hidden_deltas, @learning_rate)
      expected.zip(outputs).map { |x, y| (x - y) ** 2 }.reduce(:+) / expected.count.to_f
    end

    def serialize
      YAML.dump(self)
    end

    def self.from_serialized(serialized_network)
      YAML.load(serialized_network)
    end
  end
end
