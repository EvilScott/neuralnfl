require_relative '../../spec_helper'

module NeuralNFL
  describe Layer do
    let(:test_layer) do
      test_layer = Layer.new(2, 2)
      test_layer.nodes = [
          instance_double(Neuron),
          instance_double(Neuron)
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
        expect(test_layer.nodes[0]).to receive(:eval).and_return(0.25)
        expect(test_layer.nodes[1]).to receive(:eval).and_return(0.5)
        expect(test_layer.eval([0.25, 0.5])).to eq [0.25, 0.5]
      end
    end

    describe '#output_deltas' do
      it 'calculates deltas for an output layer' do
        expect(test_layer.nodes[0]).to receive(:out).exactly(3).times.and_return(0.5)
        expect(test_layer.nodes[1]).to receive(:out).exactly(3).times.and_return(0.5)
        expect(test_layer.output_deltas([1, 1])).to eq [0.125, 0.125]
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
