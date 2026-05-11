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
    @last_valid_state = nil
    snapshot!
  end

  def call
    return unless valid_current_position?

    commands.each(&method(:execute_command))

    output
  end

  private

  attr_reader :position_x,
    :position_y,
    :facing_direction,
    :table_dimensions,
    :commands,
    :output,
    :off_limits

  def execute_command(event)
    snapshot!

    case event[:command]
    when ACTIONS[:REPORT] then report; return
    when ACTIONS[:RIGHT]  then turn_right
    when ACTIONS[:LEFT]   then turn_left
    when ACTIONS[:MOVE]   then move_forward
    when ACTIONS[:PLACE]  then place(event)
    end

    restore! unless valid_current_position?
  end

  def place(event)
    @position_x = event[:position_x]
    @position_y = event[:position_y]
    @facing_direction = event[:facing_direction]
  end

  def report
    @output = [position_x, position_y, facing_direction].join(',')
  end

  def move_forward
    case @facing_direction
    when COMPASS[:NORTH] then @position_y += 1
    when COMPASS[:WEST]  then @position_x -= 1
    when COMPASS[:EAST]  then @position_x += 1
    when COMPASS[:SOUTH] then @position_y -= 1
    end
  end

  def turn_left
    @facing_direction = case facing_direction
    when COMPASS[:NORTH] then COMPASS[:WEST]
    when COMPASS[:WEST]  then COMPASS[:SOUTH]
    when COMPASS[:EAST]  then COMPASS[:NORTH]
    when COMPASS[:SOUTH] then COMPASS[:EAST]
    end
  end

  def turn_right
    @facing_direction = case facing_direction
    when COMPASS[:NORTH] then COMPASS[:EAST]
    when COMPASS[:WEST]  then COMPASS[:NORTH]
    when COMPASS[:EAST]  then COMPASS[:SOUTH]
    when COMPASS[:SOUTH] then COMPASS[:WEST]
    end
  end

  def valid_current_position?
    position_y.between?(0, table_dimensions[:y]) &&
      position_x.between?(0, table_dimensions[:x]) &&
      allowed_position?
  end

  def allowed_position?
    off_limits.none? { |limit| position_x == limit[:x] && position_y == limit[:y] }
  end

  def snapshot!
    @last_valid_state = {
      position_x: position_x,
      position_y: position_y,
      facing_direction: facing_direction
    }
  end

  def restore!
    @position_x = @last_valid_state[:position_x]
    @position_y = @last_valid_state[:position_y]
    @facing_direction = @last_valid_state[:facing_direction]
  end
end
