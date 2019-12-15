#!/usr/bin/env ruby

MAIN_PROGRAM = [3,8,1001,8,10,8,105,1,0,0,21,38,55,72,93,118,199,280,361,442,99999,3,9,1001,9,2,9,1002,9,5,9,101,4,9,9,4,9,99,3,9,1002,9,3,9,1001,9,5,9,1002,9,4,9,4,9,99,3,9,101,4,9,9,1002,9,3,9,1001,9,4,9,4,9,99,3,9,1002,9,4,9,1001,9,4,9,102,5,9,9,1001,9,4,9,4,9,99,3,9,101,3,9,9,1002,9,3,9,1001,9,3,9,102,5,9,9,101,4,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,99].freeze

class Instruction
  attr_reader :opcode, :parameter_modes, :parameters, :command, :length

  DEFAULT_PARAMETER_MODE = 0.freeze

  def initialize(opcode, parameter_modes, parameters)
    @opcode = opcode
    @parameter_modes = parameter_modes
    @parameters = parameters
    @command = Computer::OPCODES[opcode][:command]
    @length = Computer::OPCODES[opcode][:instruction_length]
  end

  def parameter(position)
    @parameters[position]
  end

  def parameter_mode(position)
    @parameter_modes[position] || DEFAULT_PARAMETER_MODE
  end
end

class Computer
  class Halted < StandardError; end

  OPCODES = {
    1 =>  { command: :add,           instruction_length: 4 },
    2 =>  { command: :multiply,      instruction_length: 4 },
    3 =>  { command: :save,          instruction_length: 2 },
    4 =>  { command: :output,        instruction_length: 2 },
    5 =>  { command: :jump_if_true,  instruction_length: 3 },
    6 =>  { command: :jump_if_false, instruction_length: 3 },
    7 =>  { command: :less_than,     instruction_length: 4 },
    8 =>  { command: :equals,        instruction_length: 4 },
    99 => { command: :halt,          instruction_length: 1 }
  }.freeze

  def initialize(computer_id, program, inputs)
    @computer_id = computer_id
    @memory = program.dup
    @inputs = inputs
    @instruction_ptr = 0
    @has_halted = false
  end

  def add_input(input)
    # puts "Computer #{@computer_id}: Adding input #{input}"
    @inputs << input
  end

  def parse_instruction()
    opcode_and_parameter_modes = @memory[@instruction_ptr]

    # Get opcode from rightmost two digits
    opcode = opcode_and_parameter_modes % 100

    # Get parameter modes from remaining digits
    parameter_modes_reversed = opcode_and_parameter_modes / 100
    parameter_modes = parameter_modes_reversed.to_s.reverse.split('').map(&:to_i)

    # Get parameters from remaining values in instruction
    instruction_length = OPCODES[opcode][:instruction_length]
    parameters = @memory[@instruction_ptr + 1..@instruction_ptr + instruction_length - 1]

    Instruction.new(opcode, parameter_modes, parameters)
  end
    
  def get_operand(instruction, parameter_position)
    parameter = instruction.parameter(parameter_position)
    parameter_mode = instruction.parameter_mode(parameter_position)
    case parameter_mode
    when 0
      @memory[parameter]
    when 1
      parameter
    end
  end

  def execute_instruction(instruction)
    instruction_ptr_modified = false
    return_value = nil
    case instruction.command
    when :add
      operand1 = get_operand(instruction, 0)
      operand2 = get_operand(instruction, 1)
      output_address = instruction.parameters[2]
      @memory[output_address] = operand1 + operand2
      # puts "Computer #{@computer_id}: add: @memory[#{output_address}] = #{operand1} + #{operand2}"
    when :multiply
      operand1 = get_operand(instruction, 0)
      operand2 = get_operand(instruction, 1)
      output_address = instruction.parameters[2]
      @memory[output_address] = operand1 * operand2
      # puts "Computer #{@computer_id}: multiply: @memory[#{output_address}] = #{operand1} * #{operand2}"
    when :save
      output_address = instruction.parameters[0]
      input = @inputs.shift
      raise "INPUT IS NIL" unless input
      @memory[output_address] = input
      # puts "Computer #{@computer_id}: save: @memory[#{output_address}] = #{input}"
    when :output
      operand1 = get_operand(instruction, 0)
      # puts "Computer #{@computer_id}: output: Outputting #{operand1}"
      return_value = operand1
    when :jump_if_true
      # puts "Computer #{@computer_id}: jump_if_true"
      if get_operand(instruction, 0) != 0
        @instruction_ptr = get_operand(instruction, 1)
        instruction_ptr_modified = true
      end
    when :jump_if_false
      # puts "Computer #{@computer_id}: jump_if_false"
      if get_operand(instruction, 0) == 0
        @instruction_ptr = get_operand(instruction, 1) 
        instruction_ptr_modified = true
      end
    when :less_than
      # puts "Computer #{@computer_id}: less_than"
      operand1 = get_operand(instruction, 0)
      operand2 = get_operand(instruction, 1)
      output_address = instruction.parameters[2]
      @memory[output_address] = operand1 < operand2 ? 1 : 0
    when :equals
      # puts "Computer #{@computer_id}: equals"
      operand1 = get_operand(instruction, 0)
      operand2 = get_operand(instruction, 1)
      output_address = instruction.parameters[2]
      @memory[output_address] = operand1 == operand2 ? 1 : 0
    end
    @instruction_ptr += instruction.length unless instruction_ptr_modified
    return return_value
  end

  def execute_program
    raise "Computer has halted" if @has_halted
    loop do
      instruction = parse_instruction()
      if instruction.command == :halt
        # puts "Computer #{@computer_id}: Halting"
        @has_halted = true
        return { status: :halted }
      end
      output = execute_instruction(instruction)
      return { status: :output, output_value: output } if output
    end
  end
end

def thruster_signal(program, phase_setting_sequence)
  output_a = Computer.new('A', program, [phase_setting_sequence[0], 0]).execute_program[:output_value]
  output_b = Computer.new('B', program, [phase_setting_sequence[1], output_a]).execute_program[:output_value]
  output_c = Computer.new('C', program, [phase_setting_sequence[2], output_b]).execute_program[:output_value]
  output_d = Computer.new('D', program, [phase_setting_sequence[3], output_c]).execute_program[:output_value]
  output_e = Computer.new('E', program, [phase_setting_sequence[4], output_d]).execute_program[:output_value]
  return output_e
end

def thruster_signal_feedback_loop(program, phase_setting_sequence)
  computers = [
    Computer.new('A', program, [phase_setting_sequence[0], 0]),
    Computer.new('B', program, [phase_setting_sequence[1]]),
    Computer.new('C', program, [phase_setting_sequence[2]]),
    Computer.new('D', program, [phase_setting_sequence[3]]),
    Computer.new('E', program, [phase_setting_sequence[4]]),
  ]
  
  computer_index = 0
  last_output_from_last_computer = nil
  loop do
    next_computer_index = (computer_index + 1) % computers.length
    output_hash = computers[computer_index].execute_program
    output_status = output_hash[:status]
    output_value = output_hash[:output_value]
    if output_status == :halted && computer_index == computers.length - 1
      return last_output_from_last_computer
    end
    if computer_index == computers.length - 1 && output_value
      last_output_from_last_computer = output_value
    end
    computers[next_computer_index].add_input(output_value)
    computer_index = next_computer_index
  end
end

def max_thruster_signal(range, calculation_method)
  max = nil
  range.each do |i|
    range.each do |j|
      next if j == i
      range.each do |k|
        next if k == j || k == i
        range.each do |l|
          next if l == k || l == j || l == i
          range.each do |m|
            next if m == l || m == k || m == j || m == i
            signal = self.send(calculation_method, MAIN_PROGRAM, [i, j, k, l, m])
            max = signal if !max || signal > max
          end
        end
      end
    end
  end
  max  
end

# Part 1 - Tests
puts thruster_signal([3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0], [4, 3, 2, 1, 0]) == 43210
puts thruster_signal([3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0], [0, 1, 2, 3, 4]) == 54321
puts thruster_signal([3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0], [1, 0, 4, 3, 2]) == 65210

# Part 1 - Execute
puts max_thruster_signal(0..4, :thruster_signal)
# 368584

# Part 2 - Tests
puts thruster_signal_feedback_loop(
  [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5],
  [9,8,7,6,5]
) == 139629729
puts thruster_signal_feedback_loop(
  [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10],
  [9,7,8,5,6]
) == 18216

# Part 2 - Execute
puts max_thruster_signal(5..9, :thruster_signal_feedback_loop)
