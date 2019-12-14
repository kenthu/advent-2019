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

  def initialize(program, inputs)
    @memory = program.dup
    @inputs = inputs
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
    case instruction.command
    when :add
      operand1 = get_operand(instruction, 0)
      operand2 = get_operand(instruction, 1)
      output_address = instruction.parameters[2]
      @memory[output_address] = operand1 + operand2
    when :multiply
      operand1 = get_operand(instruction, 0)
      operand2 = get_operand(instruction, 1)
      output_address = instruction.parameters[2]
      @memory[output_address] = operand1 * operand2
    when :save
      output_address = instruction.parameters[0]
      @memory[output_address] = @inputs.shift
    when :output
      operand1 = get_operand(instruction, 0)
      return operand1
    when :jump_if_true
      if get_operand(instruction, 0) != 0
        @instruction_ptr = get_operand(instruction, 1)
        instruction_ptr_modified = true
      end
    when :jump_if_false
      if get_operand(instruction, 0) == 0
        @instruction_ptr = get_operand(instruction, 1) 
        instruction_ptr_modified = true
      end
    when :less_than
      operand1 = get_operand(instruction, 0)
      operand2 = get_operand(instruction, 1)
      output_address = instruction.parameters[2]
      @memory[output_address] = operand1 < operand2 ? 1 : 0
    when :equals
      operand1 = get_operand(instruction, 0)
      operand2 = get_operand(instruction, 1)
      output_address = instruction.parameters[2]
      @memory[output_address] = operand1 == operand2 ? 1 : 0
    end
    @instruction_ptr += instruction.length unless instruction_ptr_modified
    return nil
  end

  def execute_program
    @instruction_ptr = 0
    loop do
      instruction = parse_instruction()
      break if instruction.command == :halt
      output = execute_instruction(instruction)
      return output if output
    end
  end
end

def thruster_signal(program, phase_setting_sequence)
  output_a = Computer.new(program, [phase_setting_sequence[0], 0]).execute_program
  output_b = Computer.new(program, [phase_setting_sequence[1], output_a]).execute_program
  output_c = Computer.new(program, [phase_setting_sequence[2], output_b]).execute_program
  output_d = Computer.new(program, [phase_setting_sequence[3], output_c]).execute_program
  output_e = Computer.new(program, [phase_setting_sequence[4], output_d]).execute_program
  return output_e
end

def max_thruster_signal
  max = nil
  (0..4).each do |i|
    (0..4).each do |j|
      next if j == i
      (0..4).each do |k|
        next if k == j || k == i
        (0..4).each do |l|
          next if l == k || l == j || l == i
          (0..4).each do |m|
            next if m == l || m == k || m == j || m == i
            signal = thruster_signal(MAIN_PROGRAM, [i, j, k, l, m])
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
puts max_thruster_signal
# 368584