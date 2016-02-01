require_relative '../../spec_helper'

module NeuralNFL
  describe Neuron do
    let(:test_neuron) { Neuron.new([2.0, 3.0]) }

    describe '#eval' do
      it 'evaluates the output of the neuron and saves input/output' do
        input, output = [4.0, 5.0], 0.5
        expect(test_neuron).to receive(:weighted_sum).and_return(20.0)
        expect(test_neuron).to receive(:sigmoid).with(20.0).and_return(output)
        expect(test_neuron.eval(input)).to eq output
        expect(test_neuron.inputs).to eq input
        expect(test_neuron.out).to eq output
      end
    end

    describe '#weighted_sum' do
      it 'calculates the dot product of inputs and weights' do
        expect(test_neuron.weighted_sum([4.0, 5.0])).to eq 23.0
      end
    end

    describe '#sigmoid' do
      it 'calculates the value for the neuron' do
        expect(test_neuron.sigmoid(0).round(2)).to eq 0.5
        expect(test_neuron.sigmoid(5).round(2)).to eq 0.99
        expect(test_neuron.sigmoid(-5).round(2)).to eq 0.01
      end
    end
  end
end
