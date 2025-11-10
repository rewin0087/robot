class ExecuteCommands
  attr_accessor :dimensions,
    :commands

  def initialize(commands = [], dimension_x = nil, dimension_y = nil)
    set_dimension(dimension_x, dimension_y)
    @commands =  commands.compact
    @actions = Robot::ACTIONS.clone.values
    @actions.delete('PLACE')
  end

  def call
    filtered_commands = commands.select(&method(:filter_event))
    place_command = filtered_commands.shift
    total_commands = filtered_commands.size

    if place_command[:command] != Robot::ACTIONS[:PLACE]
      place_command = nil
      next_place_command_index = filtered_commands.index{|c| c[:command] == Robot::ACTIONS[:PLACE] }

      unless next_place_command_index.nil?
        @filtered_commands = filtered_commands[next_place_command_index..total_commands]
        place_command = @filtered_commands.shift
      end
    end

    return if place_command.nil?

    Robot.new(
      place_command[:position_x],
      place_command[:position_y],
      place_command[:facing],
      @dimensions,
      filtered_commands
    ).call
  end

  private

  attr_reader :commands, :dimensions, :actions

  def filter_event(event)
    (
      event[:command] == Robot::ACTIONS[:PLACE] &&
      event[:position_x] >= 0 &&
      event[:position_x] <= dimensions[:x] &&
      event[:position_y] >= 0 &&
      event[:position_y] <= dimensions[:y]
    ) || actions.include?(event[:command])
  end

  def set_dimension(dimension_x, dimension_y)
    @dimensions =  if dimension_x && dimension_y
      { x: dimension_x, y: dimension_y }
    else
      { x: 6, y: 6 }
    end
  end
end
