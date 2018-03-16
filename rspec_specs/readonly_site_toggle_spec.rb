require 'rails_helper'

RSpec.describe ReadonlySiteToggle do
  describe '.reset_configuration!' do
    before do
      ReadonlySiteToggle.config do |config|
        config.read_only = true
      end

      ReadonlySiteToggle.reset_configuration!
    end

    subject { ReadonlySiteToggle.config }

    it 'sets `read_only` to false' do
      expect(ReadonlySiteToggle.config.read_only).to eq(false)
    end
  end

  describe '.override_readonly_method' do
    let(:klass) { User }

    before do
      ReadonlySiteToggle.config do |config|
        config.read_only = true
      end

      ReadonlySiteToggle.reload!

      ReadonlySiteToggle.send(:override_readonly_method, klass)
    end

    describe 'An ActiveRecord object\'s #readonly? method' do
      subject { klass.new.readonly? }

      it { is_expected.to eq(true) }
    end
  end

  describe '.restore_readonly_method' do
    let(:klass) { User }

    before do
      ReadonlySiteToggle.config do |config|
        config.read_only = false
      end

      ReadonlySiteToggle.reload!

      ReadonlySiteToggle.send(:restore_readonly_method, klass)
    end

    describe('An ActiveRecord object\'s #readonly? method') do
      subject { klass.new.readonly? }

      it { is_expected.to eq(false) }
    end
  end
end
