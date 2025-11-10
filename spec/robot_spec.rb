require_relative '../lib/robot'

RSpec.describe Robot do
  describe 'constants' do
    it { expect(described_class::COMPASS).to eql(NORTH: 'N', SOUTH: 'S', WEST: 'W', EAST: 'E') }
    it { expect(described_class::ACTIONS).to eql(LEFT: 'LEFT', RIGHT: 'RIGHT', MOVE: 'MOVE', REPORT: 'REPORT', PLACE: 'PLACE') }
  end

  describe '#methods' do
    context '#call' do
      let(:commands) do
        [
          { command: 'MOVE' },
          { command: 'MOVE' },
          { command: 'LEFT' },
          { command: 'MOVE' },
          { command: 'RIGHT' },
          { command: 'MOVE' },
          { command: 'REPORT' }
        ]
      end

      let(:position_x) { 0 }
      let(:position_y) { 0 }
      let(:facing_direction) { 'N' }

      subject { described_class.new(position_x, position_y, facing_direction, { x: 5, y: 5 }, commands).call }

      it { is_expected.to eq('0,3,N') }

      context 'scenario A' do
        let(:facing_direction) { 'E' }
        let(:commands) do
          [
            { command: 'MOVE' },
            { command: 'REPORT' }
          ]
        end

        it { is_expected.to eq('1,0,E') }
      end

      context 'scenario B' do
        let(:commands) do
          [
            { command: 'MOVE' },
            { command: 'MOVE' },
            { command: 'RIGHT' },
            { command: 'MOVE' },
            { command: 'REPORT' }
          ]
        end

        it { is_expected.to eq('1,2,E') }
      end

      context 'scenario C' do
        let(:commands) do
          [
            { command: 'MOVE' },
            { command: 'REPORT' }
          ]
        end

        it { is_expected.to eq('0,1,N') }
      end

      context 'scenario D' do
        let(:commands) do
          [
            { command: 'LEFT' },
            { command: 'REPORT' }
          ]
        end

        it { is_expected.to eq('0,0,W') }
      end

      context 'scenario E' do
        let(:position_x) { 1 }
        let(:position_y) { 2 }
        let(:facing_direction) { 'E' }
        let(:commands) do
          [
            { command: 'MOVE' },
            { command: 'MOVE' },
            { command: 'LEFT' },
            { command: 'MOVE' },
            { command: 'REPORT' }
          ]
        end

        it { is_expected.to eq('3,3,N') }
      end

      context 'scenario F' do
        let(:position_x) { 5 }
        let(:position_y) { 5 }
        let(:commands) do
          [
            { command: 'MOVE' },
            { command: 'MOVE' },
            { command: 'MOVE' },
            { command: 'REPORT' }
          ]
        end

        it { is_expected.to eq('5,5,N') }
      end
    end
  end
end
