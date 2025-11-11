require_relative 'constants'

class Robot
  include Constants

  def initialize(initial_position_x, initial_position_y, initial_facing_direction, table_dimensions, commands, off_limits = [])
    @position_x = initial_position_x
    @position_y = initial_position_y
    @facing_direction = initial_facing_direction
    @table_dimensions = table_dimensions
    @off_limits = off_limits
    @commands = commands
    @movement_history = []
    save_current_state!
  end

  def call
    return unless valid_current_position?

    commands.map(&method(:execute_command))

    output
  end

  private

  attr_reader :position_x,
    :position_y,
    :facing_direction,
    :table_dimensions,
    :commands,
    :movement_history,
    :output,
    :off_limits

  def execute_command(event)
    case event[:command]
      when ACTIONS[:RIGHT] then turn_right
      when ACTIONS[:LEFT] then turn_left
      when ACTIONS[:MOVE] then move_forward
      when ACTIONS[:REPORT] then report
      when ACTIONS[:PLACE] then place(event)
      else nil
      end

    save_current_state!
    validate_latest_position!
  end

  def place(event)
    @position_x = event[:position_x]
    @position_y = event[:position_y]
    @facing_direction = event[:facing]
  end

  def report
    @output = [position_x, position_y, facing_direction].join(',')
  end

  def move_forward
    case @facing_direction
      when COMPASS[:NORTH] then @position_y += 1
      when COMPASS[:WEST] then @position_x -= 1
      when COMPASS[:EAST] then @position_x += 1
      when COMPASS[:SOUTH] then @position_y -= 1
      else nil
      end
  end

  def turn_left
    @facing_direction = case facing_direction
      when COMPASS[:NORTH] then COMPASS[:WEST]
      when COMPASS[:WEST] then COMPASS[:SOUTH]
      when COMPASS[:EAST] then COMPASS[:NORTH]
      when COMPASS[:SOUTH] then COMPASS[:EAST]
      else nil
      end
  end

  def turn_right
    @facing_direction = case facing_direction
      when COMPASS[:NORTH] then COMPASS[:EAST]
      when COMPASS[:WEST] then COMPASS[:NORTH]
      when COMPASS[:EAST] then COMPASS[:SOUTH]
      when COMPASS[:SOUTH] then COMPASS[:WEST]
      else nil
      end
  end

  def validate_latest_position!
    return if valid_current_position?

    @movement_history.pop
    last_position = movement_history.last
    # set last position
    @position_x = last_position[:position_x]
    @position_y = last_position[:position_y]
    @facing_direction = last_position[:facing_direction]
  end

  def valid_current_position?
    position_y <= table_dimensions[:y] &&
      position_x <= table_dimensions[:x] &&
      position_y >= 0 &&
      position_x >= 0 &&
      on_bound?
  end

  def on_bound?
    off_limits.count { |limit| position_x == limit[:x] && position_y == limit[:y] }.zero?
  end

  def save_current_state!
    last_command = {
      position_y: position_y,
      position_x: position_x,
      facing_direction: facing_direction
    }

    @movement_history << last_command
  end
end