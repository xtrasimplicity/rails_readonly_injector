require 'rails_helper'

RSpec.describe RailsReadonlyInjector do
  describe '.reset_configuration!' do
    before do
      RailsReadonlyInjector.config do |config|
        config.read_only = true
      end

      RailsReadonlyInjector.reset_configuration!
    end

    subject { RailsReadonlyInjector.config }

    it 'sets `read_only` to false' do
      expect(RailsReadonlyInjector.config.read_only).to eq(false)
    end
  end

  describe '.override_readonly_method' do
    let(:klass) { User }

    before do
      RailsReadonlyInjector.config do |config|
        config.read_only = true
      end

      RailsReadonlyInjector.reload!

      RailsReadonlyInjector.send(:override_readonly_method, klass)
    end

    describe 'An ActiveRecord object\'s #readonly? method' do
      subject { klass.new.readonly? }

      it { is_expected.to eq(true) }
    end
  end

  describe '.restore_readonly_method' do
    let(:klass) { User }

    before do
      RailsReadonlyInjector.config do |config|
        config.read_only = false
      end

      RailsReadonlyInjector.reload!

      RailsReadonlyInjector.send(:restore_readonly_method, klass)
    end

    describe('An ActiveRecord object\'s #readonly? method') do
      subject { klass.new.readonly? }

      it { is_expected.to eq(false) }
    end
  end

  describe '#in_read_only_mode?' do
    setup do
      RailsReadonlyInjector.config.read_only = false
      RailsReadonlyInjector.reload!
    end

    context 'when `reload!` is called' do
      before do
        RailsReadonlyInjector.config.read_only = true
        RailsReadonlyInjector.reload!
      end

      it 'returns the correct value' do
        expect(RailsReadonlyInjector.in_read_only_mode?).to eq(true)
      end
    end

    context 'when `reload!` is not called' do
      before do
        RailsReadonlyInjector.config.read_only = true
      end

      it 'returns the previous value' do
        expect(RailsReadonlyInjector.in_read_only_mode?).to eq(false)
      end
    end
  end
end
