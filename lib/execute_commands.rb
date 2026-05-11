require_relative 'robot'

class ExecuteCommands
  def initialize(commands = [], dimension_x = nil, dimension_y = nil, off_limits = [])
    set_dimension(dimension_x, dimension_y)
    @commands = commands.compact
    @off_limits = off_limits
    @actions = Robot::ACTIONS.values.reject { |a| a == Robot::ACTIONS[:PLACE] }
  end

  def call
    filtered = commands.select(&method(:filter_event))
    place_command = filtered.shift

    if place_command.nil? || place_command[:command] != Robot::ACTIONS[:PLACE]
      place_index = filtered.index { |c| c[:command] == Robot::ACTIONS[:PLACE] }
      return if place_index.nil?

      filtered = filtered[place_index..]
      place_command = filtered.shift
    end

    Robot.new(
      place_command[:position_x],
      place_command[:position_y],
      place_command[:facing_direction],
      dimensions,
      filtered,
      off_limits
    ).call
  end

  private

  attr_reader :commands, :dimensions, :actions, :off_limits

  def filter_event(event)
    if event[:command] == Robot::ACTIONS[:PLACE]
      event[:position_x] >= 0 &&
        event[:position_x] <= dimensions[:x] &&
        event[:position_y] >= 0 &&
        event[:position_y] <= dimensions[:y] &&
        allowed_position?(event)
    else
      actions.include?(event[:command])
    end
  end

  def allowed_position?(event)
    off_limits.none? { |limit| event[:position_x] == limit[:x] && event[:position_y] == limit[:y] }
  end

  def set_dimension(dimension_x, dimension_y)
    @dimensions = if dimension_x && dimension_y
      { x: dimension_x, y: dimension_y }
    else
      { x: 10, y: 10 }
    end
  end
end
