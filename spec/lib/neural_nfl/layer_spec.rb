require_relative '../../spec_helper'

module NeuralNFL
  describe Layer do
    let(:test_layer) do
      test_layer = Layer.new(3, 2)
      test_layer.nodes = [
          instance_double('Neuron', eval: 0.0, out: 0.0),
          instance_double('Neuron', eval: 0.5, out: 0.5),
          instance_double('Neuron', eval: 1.0, out: 1.0)
      ]
      test_layer
    end

    describe '#random_node' do
      it 'creates a random neuron' do
        node = test_layer.random_node(3)
        expect(node).to be_instance_of Neuron
        expect(node.weights.length).to eq 3
        expect(node.weights.all? { |w| w.between?(-1.0, 1.0) }).to be true
      end
    end

    describe '#eval' do
      it 'evaluates a layer of neurons and returns an array of outputs' do
        expect(test_layer.eval(nil)).to eq [0.0, 0.5, 1.0]
      end
    end

    describe '#output_deltas' do
      it 'calculates deltas for an output layer' do
        expect(test_layer.output_deltas([0.0, -0.5, 1.0])).to eq [0.0, -0.25, 0.0]
      end
    end

    describe '#hidden_deltas' do
      pending
      # it 'calculates deltas for a hidden layer' do
      # end
    end

    describe '#update_weights!' do
      pending
      # it 'updates weights based off deltas and a learning rate' do
      # end
    end
  end
end
