class ExtractCommand
  def initialize(line)
    @sequence = line.strip
  end

  def call
    return place_command if sequence.include?(Robot::ACTIONS[:PLACE])
    return unless Robot::ACTIONS.values.include?(sequence)

    { command: sequence }
  end

  private

  def place_command
    place = Robot::ACTIONS[:PLACE]
    initial_position = sequence.sub(place, '').strip.split(',')
    return if initial_position.size != 3

    position_x = initial_position[0].to_i
    position_y = initial_position[1].to_i
    facing = initial_position[2]

    return unless Robot::COMPASS.values.include?(facing)

    { command: place, position_x: position_x, position_y: position_y, facing: facing }
  end

  attr_reader :sequence
end
