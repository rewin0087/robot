require_relative '../lib/extract_command'
require_relative '../lib/robot'

RSpec.describe ExtractCommand do
  describe '#call' do
    let(:line) { 'PLACE 0,0,N' }

    subject { described_class.new(line).call }

    context 'when PLACE command' do
      let(:expected) { { command: 'PLACE', position_x: 0, position_y:0, facing: 'N' } }

      it { is_expected.to eq(expected) }
    end

    context 'when LEFT command' do
      let(:line) { 'LEFT' }
      let(:expected) { { command: 'LEFT' } }

      it { is_expected.to eq(expected) }
    end

    context 'when RIGHT command' do
      let(:line) { 'RIGHT' }
      let(:expected) { { command: 'RIGHT' } }

      it { is_expected.to eq(expected) }
    end

    context 'when MOVE command' do
      let(:line) { 'MOVE' }
      let(:expected) { { command: 'MOVE' } }

      it { is_expected.to eq(expected) }
    end

    context 'when REPORT command' do
      let(:line) { 'REPORT' }
      let(:expected) { { command: 'REPORT' } }

      it { is_expected.to eq(expected) }
    end

    context 'when invalid INVALID command' do
      let(:line) { 'INVALID' }

      it { is_expected.to be_nil }
    end

    context 'when invalid OTHER command' do
      let(:line) { 'OTHER' }

      it { is_expected.to be_nil }
    end

    context 'when invalid PLACE command' do
      let(:line) { 'PALCES 0,0,N' }

      it { is_expected.to be_nil }
    end
  end
end
