require_relative '../../spec_helper'

module NeuralNFL
  describe Network do
    let (:net) { Network.new(1, 3, 2, 0.25) }

    describe '#evaluate' do
      pending
    end

    describe '#train' do
      pending
    end

    describe '#get_output_deltas' do
      #TODO add more assertions in multiple it blocks for documentation/clarity
      it 'provides deltas for the output layer' do
        expected = [1.0, 0.0]
        output = [0.5, 0.25]
        expect(net.get_output_deltas(expected, output)).to eq [0.125, -0.046875]
      end
    end

    describe '#get_hidden_deltas' do
      pending
    end

    describe '#update_output_weights!' do
      pending
    end

    describe '#update_hidden_weights!' do
      pending
    end
  end
end
