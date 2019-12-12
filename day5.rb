#!/usr/bin/env ruby

MAIN_PROGRAM = [3,225,1,225,6,6,1100,1,238,225,104,0,1102,72,20,224,1001,224,-1440,224,4,224,102,8,223,223,1001,224,5,224,1,224,223,223,1002,147,33,224,101,-3036,224,224,4,224,102,8,223,223,1001,224,5,224,1,224,223,223,1102,32,90,225,101,65,87,224,101,-85,224,224,4,224,1002,223,8,223,101,4,224,224,1,223,224,223,1102,33,92,225,1102,20,52,225,1101,76,89,225,1,117,122,224,101,-78,224,224,4,224,102,8,223,223,101,1,224,224,1,223,224,223,1102,54,22,225,1102,5,24,225,102,50,84,224,101,-4600,224,224,4,224,1002,223,8,223,101,3,224,224,1,223,224,223,1102,92,64,225,1101,42,83,224,101,-125,224,224,4,224,102,8,223,223,101,5,224,224,1,224,223,223,2,58,195,224,1001,224,-6840,224,4,224,102,8,223,223,101,1,224,224,1,223,224,223,1101,76,48,225,1001,92,65,224,1001,224,-154,224,4,224,1002,223,8,223,101,5,224,224,1,223,224,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1107,677,226,224,1002,223,2,223,1005,224,329,101,1,223,223,7,677,226,224,102,2,223,223,1005,224,344,1001,223,1,223,1107,226,226,224,1002,223,2,223,1006,224,359,1001,223,1,223,8,226,226,224,1002,223,2,223,1006,224,374,101,1,223,223,108,226,226,224,102,2,223,223,1005,224,389,1001,223,1,223,1008,226,226,224,1002,223,2,223,1005,224,404,101,1,223,223,1107,226,677,224,1002,223,2,223,1006,224,419,101,1,223,223,1008,226,677,224,1002,223,2,223,1006,224,434,101,1,223,223,108,677,677,224,1002,223,2,223,1006,224,449,101,1,223,223,1108,677,226,224,102,2,223,223,1006,224,464,1001,223,1,223,107,677,677,224,102,2,223,223,1005,224,479,101,1,223,223,7,226,677,224,1002,223,2,223,1006,224,494,1001,223,1,223,7,677,677,224,102,2,223,223,1006,224,509,101,1,223,223,107,226,677,224,1002,223,2,223,1006,224,524,1001,223,1,223,1007,226,226,224,102,2,223,223,1006,224,539,1001,223,1,223,108,677,226,224,102,2,223,223,1005,224,554,101,1,223,223,1007,677,677,224,102,2,223,223,1006,224,569,101,1,223,223,8,677,226,224,102,2,223,223,1006,224,584,1001,223,1,223,1008,677,677,224,1002,223,2,223,1006,224,599,1001,223,1,223,1007,677,226,224,1002,223,2,223,1005,224,614,101,1,223,223,1108,226,677,224,1002,223,2,223,1005,224,629,101,1,223,223,1108,677,677,224,1002,223,2,223,1005,224,644,1001,223,1,223,8,226,677,224,1002,223,2,223,1006,224,659,101,1,223,223,107,226,226,224,102,2,223,223,1005,224,674,101,1,223,223,4,223,99,226].freeze

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

  def initialize(program, input)
    @memory = program.dup
    @input = input
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
      @memory[output_address] = @input
    when :output
      operand1 = get_operand(instruction, 0)
      puts "OUTPUT: #{operand1}"
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
  end

  def execute_program
    @instruction_ptr = 0
    loop do
      instruction = parse_instruction()
      break if instruction.command == :halt
      execute_instruction(instruction)
    end
  end
end

# Part 1
computer = Computer.new(MAIN_PROGRAM, 1)
puts computer.execute_program()
# 11933517

# Part 2
computer = Computer.new(MAIN_PROGRAM, 5)
puts computer.execute_program()
# 10428568
