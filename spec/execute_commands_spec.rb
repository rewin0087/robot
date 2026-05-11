require_relative '../lib/execute_commands'
require_relative '../lib/robot'

RSpec.describe ExecuteCommands do
  describe '#call' do
    let(:commands) do
      [
        { command: 'MOVE' },
        { command: 'MOVE' },
        { command: 'RIGHT' },
        { command: 'MOVE' },
        { command: 'REPORT' }
      ]
    end

    let(:complete_commands) do
      [{ command: 'PLACE', position_x: 0, position_y: 0, facing_direction: 'N' }] + commands
    end

    subject { described_class.new(complete_commands).call }

    it 'execute the commands' do
      expect(Robot).to receive(:new).with(0, 0, 'N', { x: 10, y: 10 }, commands, []).and_call_original

      is_expected.to eq('1,2,E')
    end

    context 'when has invalid command' do
      let(:complete_commands) do
        [{ command: 'PALCE', position_x: 0, position_y: 0, facing_direction: 'N' }] + commands
      end

      it 'returns nil' do
        expect(Robot).not_to receive(:new).with(0, 0, 'N', { x: 6, y: 6 }, commands)

        is_expected.to be_nil
      end
    end

    context 'when no PLACE command' do
      let(:complete_commands) do
        [nil] + commands
      end

      it 'returns nil' do
        expect(Robot).not_to receive(:new).with(0, 0, 'N', { x: 6, y: 6 }, commands)

        is_expected.to be_nil
      end
    end

    context 'when PLACE is out of bounds' do
      let(:complete_commands) do
        [{ command: 'PLACE', position_x: 11, position_y: 0, facing_direction: 'N' }] + commands
      end

      it 'returns nil' do
        is_expected.to be_nil
      end
    end

    context 'when PLACE is on an off-limits position' do
      let(:complete_commands) do
        [{ command: 'PLACE', position_x: 4, position_y: 4, facing_direction: 'N' }] + commands
      end

      subject { described_class.new(complete_commands, nil, nil, [{ x: 4, y: 4 }]).call }

      it 'returns nil' do
        is_expected.to be_nil
      end
    end

    context 'when PLACE comes after non-PLACE commands' do
      let(:complete_commands) do
        [{ command: 'MOVE' }, { command: 'PLACE', position_x: 0, position_y: 0, facing_direction: 'N' }] + commands
      end

      it 'skips to the first PLACE command' do
        is_expected.to eq('1,2,E')
      end
    end

    context 'when command list is empty' do
      subject { described_class.new([]).call }

      it 'returns nil' do
        is_expected.to be_nil
      end
    end
  end
end
