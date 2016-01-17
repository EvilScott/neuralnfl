module NeuralNFL
  class Network
    attr_accessor :hidden_layers, :output_layer

    def initialize(input_count, layer_counts)
      layers = layer_counts.zip([input_count] + layer_counts).map { |lc, pc| Layer.new(pc, lc) }
      @output_layer = layers.pop
      @hidden_layers = layers
    end

    def eval(inputs)
      (@hidden_layers + [@output_layer]).inject(inputs) { |ins, layer| layer.eval(ins) }
    end

    def train
      # TODO eval + backprop
    end

    def backprop
      # TODO backpropagation algorithm
    end

    def serialize
      # TODO serialize weights and layer counts
    end
  end
end
