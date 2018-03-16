require 'rails_helper'

RSpec.describe ReadonlySiteToggle.config do
  describe '#controller_rescue_action=' do
    context 'when given a lambda expression' do
      let(:lambda_expression) { lambda { "This is a test lambda!" } }

      before { ReadonlySiteToggle.config.controller_rescue_action = lambda_expression }

      subject { ReadonlySiteToggle.config.controller_rescue_action }

      it { is_expected.to eq(lambda_expression) }
    end

    context 'when given a Proc' do
      let(:proc) { Proc.new { "This is a test Proc!" } }

      before { ReadonlySiteToggle.config.controller_rescue_action = proc }

      subject { ReadonlySiteToggle.config.controller_rescue_action }

      it { is_expected.to eq(proc) }
    end

    context 'when an invalid value is assigned' do
      it 'raises an error message' do
        expect { ReadonlySiteToggle.config.controller_rescue_action = nil }.to raise_error 'A lambda or proc must be specified'
      end
    end
  end
end