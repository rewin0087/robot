require_relative 'constants'

class ExtractCommand
  include Constants

  def initialize(line)
    @sequence = line.strip
  end

  def call
    return place_command if sequence.start_with?("#{ACTIONS[:PLACE]} ")
    return unless ACTIONS.values.include?(sequence)

    { command: sequence }
  end

  private

  def place_command
    place = ACTIONS[:PLACE]
    parts = sequence.sub(place, '').strip.split(',').map(&:strip)
    return if parts.size != 3

    return unless parts[0].match?(/\A\d+\z/) && parts[1].match?(/\A\d+\z/)

    position_x = parts[0].to_i
    position_y = parts[1].to_i
    facing_direction = parts[2]

    return unless COMPASS.values.include?(facing_direction)

    { command: place, position_x: position_x, position_y: position_y, facing_direction: facing_direction }
  end

  attr_reader :sequence
end
