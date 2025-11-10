Dir['lib/**/*.rb'].each do |file|
  require File.join(File.dirname(__dir__), file)
end

puts 'Please enter your command:'

commands = []
ARGF.each_line do |line|
  begin
    commands.compact!
    extracted = ExtractCommand.new(line).call
    commands << extracted

    next unless extracted[:command] == Robot::ACTIONS[:REPORT]
    outcome =  ExecuteCommands.new(commands).call

    puts "OUTPUT: #{outcome}"
  rescue StandardError => e
    puts "Invalid command: #{e.message}"
  end
end
