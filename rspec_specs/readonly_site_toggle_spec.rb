require 'spec_helper'

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
end
