require 'rails_helper'

RSpec.describe RailsReadonlyInjector.config do
  describe '#controller_rescue_action=' do
    context 'when given a lambda expression' do
      let(:lambda_expression) { lambda { "This is a test lambda!" } }

      before { RailsReadonlyInjector.config.controller_rescue_action = lambda_expression }

      subject { RailsReadonlyInjector.config.controller_rescue_action }

      it { is_expected.to eq(lambda_expression) }
    end

    context 'when given a Proc' do
      let(:proc) { Proc.new { "This is a test Proc!" } }

      before { RailsReadonlyInjector.config.controller_rescue_action = proc }

      subject { RailsReadonlyInjector.config.controller_rescue_action }

      it { is_expected.to eq(proc) }
    end

    context 'when an invalid value is assigned' do
      it 'raises an error message' do
        expect { RailsReadonlyInjector.config.controller_rescue_action = nil }.to raise_error 'A lambda or proc must be specified'
      end
    end
  end

  describe '#classes_to_include' do
    context 'when not defined' do
      context 'when using Rails < 5.0' do
        before { stub_const('Rails::VERSION::STRING', '4.1.0') }

        it 'returns the descendants of ActiveRecord::Base' do
          expect(ActiveRecord::Base).to receive(:descendants)

          RailsReadonlyInjector.config.classes_to_include
        end

      end

      context 'when using Rails >= 5.0' do
        before do
          stub_const('Rails::VERSION::STRING', '5.0.0')
          
          unless defined? ApplicationRecord
            class ApplicationRecord
              def descendants
              end
            end
          end
        end

        it 'returns the descendants of ActiveRecord::Base' do
          expect(ApplicationRecord).to receive(:descendants)

          RailsReadonlyInjector.config.classes_to_include
        end

      end
    end
  end
end