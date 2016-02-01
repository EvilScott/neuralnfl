require_relative '../../spec_helper'

module NeuralNFL
  describe Neuron do
    let(:test_neuron) { Neuron.new([2.0, 3.0]) }

    describe '#eval' do
      pending
      # it 'evaluates the output of the neuron and saves input/output' do
      # end
    end

    describe '#weighted_sum' do
      it 'calculates the dot product of inputs and weights' do
        expect(test_neuron.weighted_sum([4.0, 5.0])).to eq 23.0
      end
    end

    describe '#sigmoid' do
      pending
      # it 'calculates the value for the neuron' do
      # end
    end
  end
end
