require_relative '../../spec_helper'

module NeuralNFL
  describe Network do
    let(:test_network) { Network.new(1, 1, 1, 0.25) }

    describe '#evaluate' do
      it 'returns the output of the network given a set of inputs' do
        expect(test_network.hidden_layer).to receive(:evaluate).with([0.5]).and_return([0.25])
        expect(test_network.output_layer).to receive(:evaluate).with([0.25]).and_return([0.75])
        expect(test_network.evaluate([0.5])).to eq [0.75]
      end
    end

    describe '#train!' do
      it 'trains the network' do
        output_nodes = test_network.output_layer.nodes
        expect(test_network).to receive(:evaluate).and_return([0.5])
        expect(test_network.output_layer).to receive(:output_deltas).with([0.5]).and_return([0.25])
        expect(test_network.hidden_layer).to receive(:hidden_deltas).with(output_nodes, [0.25]).and_return([0.5])
        expect(test_network.output_layer).to receive(:update_weights!).with([0.25], 0.25).and_return([0.25])
        expect(test_network.hidden_layer).to receive(:update_weights!).with([0.5], 0.25).and_return([0.5])
        test_network.train!([0.5], [0.5])
      end
    end

    describe '#serialize' do
      it 'serializes the network into YAML' do
        expect(test_network.serialize).to be_a String
      end
    end

    describe '.from_serialized' do
      it 'returns a network from serialized YAML' do
        expect(Network.from_serialized(test_network.serialize)).to be_an_instance_of Network
      end
    end
  end
end
