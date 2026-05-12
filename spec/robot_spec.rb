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

        it { is_expected.to eq('5,2,N') }
      end

      context 'scenario G - when at the corner facing south' do
        let(:position_x) { 0 }
        let(:position_y) { 0 }
        let(:facing_direction) { 'S' }
        let(:commands) do
          [
            { command: 'MOVE' },
            { command: 'REPORT' }
          ]
        end

        it { is_expected.to eq('0,5,S') }
      end

      context 'scenario H - when at the edge facing west' do
        let(:position_x) { 0 }
        let(:position_y) { 3 }
        let(:facing_direction) { 'W' }
        let(:commands) do
          [
            { command: 'MOVE' },
            { command: 'REPORT' }
          ]
        end

        it { is_expected.to eq('0,3,W') }
      end

      context 'when initial position is off limits' do
        subject { described_class.new(1, 1, 'N', { x: 5, y: 5 }, [], [{ x: 1, y: 1 }]).call }

        it { is_expected.to be_nil }
      end

      context 'when a move would enter an off-limits cell' do
        let(:position_x) { 1 }
        let(:position_y) { 0 }
        let(:commands) do
          [
            { command: 'MOVE' },
            { command: 'REPORT' }
          ]
        end

        subject { described_class.new(position_x, position_y, 'N', { x: 5, y: 5 }, commands, [{ x: 1, y: 1 }]).call }

        it 'stays at the last valid position' do
          is_expected.to eq('1,0,N')
        end
      end

      context 'when a mid-sequence PLACE lands on an off-limits cell' do
        let(:commands) do
          [
            { command: 'PLACE', position_x: 2, position_y: 2, facing_direction: 'N' },
            { command: 'REPORT' }
          ]
        end

        subject { described_class.new(0, 0, 'N', { x: 5, y: 5 }, commands, [{ x: 2, y: 2 }]).call }

        it 'reverts to the position before the PLACE' do
          is_expected.to eq('0,0,N')
        end
      end
    end
  end
end
