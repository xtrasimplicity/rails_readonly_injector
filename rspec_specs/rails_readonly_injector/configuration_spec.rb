# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RailsReadonlyInjector.config do
  describe '#controller_rescue_action=' do
    context 'when given a lambda expression' do
      let(:exp) { -> { 'This is a test lambda!' } }
      before do
        RailsReadonlyInjector.config.controller_rescue_action = exp
      end

      subject { RailsReadonlyInjector.config.controller_rescue_action }

      it { is_expected.to eq(exp) }
    end

    context 'when given a Proc' do
      let(:passed_proc) { proc { 'This is a test Proc!' } }

      before do
        RailsReadonlyInjector.config.controller_rescue_action = passed_proc
      end

      subject { RailsReadonlyInjector.config.controller_rescue_action }

      it { is_expected.to eq(passed_proc) }
    end

    context 'when an invalid value is assigned' do
      it 'raises an error message' do
        expect do
          RailsReadonlyInjector.config.controller_rescue_action = nil
        end.to raise_error 'A lambda or proc must be specified'
      end
    end
  end

  describe '#classes_to_include' do
    context 'when not defined' do
      context 'when using Rails < 5.0' do
        before do
          stub_const('Rails::VERSION::STRING', '4.1.0')
        end

        it 'returns the descendants of ActiveRecord::Base' do
          expect(ActiveRecord::Base).to receive(:descendants)

          RailsReadonlyInjector.config.classes_to_include
        end
      end

      context 'when using Rails >= 5.0' do
        before do
          stub_const('Rails::VERSION::STRING', '5.0.0')

          unless defined? ApplicationRecord
            # :nodoc:
            class ApplicationRecord
              def descendants; end
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

  describe '#changed_attributes' do
    setup do
      RailsReadonlyInjector.reset_configuration!

      RailsReadonlyInjector.config.read_only = false
    end

    context 'when one attribute is changed' do
      before(:each) do
        RailsReadonlyInjector.config.read_only = true
      end

      context 'and `reload!` is not called' do
        subject { RailsReadonlyInjector.config.changed_attributes }

        it 'returns a hash with the attribute and its old value' do
          expect(subject).to eq(read_only: false)
        end
      end

      context 'and `reload!` is called' do
        before { RailsReadonlyInjector.reload! }
        subject { RailsReadonlyInjector.config.changed_attributes }

        it 'returns an empty hash' do
          expect(subject).to eq({})
        end
      end
    end

    context 'when more than one attribute is changed' do
      setup { class TestClassA < ActiveRecord::Base; end; }

      before(:each) do
        RailsReadonlyInjector.config do |c|
          c.read_only = true
          c.classes_to_include = [TestClassA]
          c.classes_to_exclude = [User]
        end
      end

      context 'and `reload!` is not called' do
        subject { RailsReadonlyInjector.config.changed_attributes }

        it 'returns a hash with the attribute and its old value' do
          expect(subject).to eq(
            read_only: false,
            classes_to_include: nil,
            classes_to_exclude: []
          )
        end
      end

      context 'and `reload!` is called' do
        before { RailsReadonlyInjector.reload! }
        subject { RailsReadonlyInjector.config.changed_attributes }

        it 'returns an empty hash' do
          expect(subject).to eq({})
        end
      end
    end

    context 'when an attribute is not changed' do
      subject { RailsReadonlyInjector.config.changed_attributes }

      it { is_expected.to eq({}) }
    end
  end

  describe '#dirty?' do
    setup do
      RailsReadonlyInjector.config { |config| config.read_only = false }
      RailsReadonlyInjector.reload!
    end

    context 'when `read_only` is changed' do
      before(:each) { RailsReadonlyInjector.config.read_only = true }

      context 'and `reload!` is not called' do
        subject { RailsReadonlyInjector.config.dirty? }

        it { is_expected.to eq(true) }
      end

      context 'and `reload!` is called' do
        before { RailsReadonlyInjector.reload! }
        subject { RailsReadonlyInjector.config.dirty? }

        it { is_expected.to eq(false) }
      end
    end
  end
end
