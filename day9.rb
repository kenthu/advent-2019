#!/usr/bin/env ruby

TEST_1 = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
TEST_2 = [1102,34915192,34915192,7,4,7,99,0]
TEST_3 = [104,1125899906842624,99]
MAIN_PROGRAM = [1102,34463338,34463338,63,1007,63,34463338,63,1005,63,53,1101,3,0,1000,109,988,209,12,9,1000,209,6,209,3,203,0,1008,1000,1,63,1005,63,65,1008,1000,2,63,1005,63,904,1008,1000,0,63,1005,63,58,4,25,104,0,99,4,0,104,0,99,4,17,104,0,99,0,0,1102,1,550,1027,1101,0,0,1020,1101,30,0,1004,1101,0,22,1014,1102,1,36,1009,1101,37,0,1007,1102,25,1,1010,1102,1,33,1012,1102,282,1,1029,1102,1,488,1025,1101,0,31,1019,1101,0,21,1008,1101,0,35,1015,1101,664,0,1023,1102,26,1,1001,1101,28,0,1016,1102,29,1,1005,1102,1,24,1002,1101,20,0,1018,1101,27,0,1013,1101,38,0,1017,1102,1,1,1021,1102,1,557,1026,1102,1,39,1000,1101,23,0,1006,1101,493,0,1024,1102,1,291,1028,1101,671,0,1022,1101,0,34,1003,1101,0,32,1011,109,10,21108,40,40,8,1005,1018,199,4,187,1105,1,203,1001,64,1,64,1002,64,2,64,109,-14,2108,30,8,63,1005,63,225,4,209,1001,64,1,64,1105,1,225,1002,64,2,64,109,3,2102,1,4,63,1008,63,34,63,1005,63,251,4,231,1001,64,1,64,1106,0,251,1002,64,2,64,109,12,2107,22,-5,63,1005,63,269,4,257,1105,1,273,1001,64,1,64,1002,64,2,64,109,20,2106,0,-3,4,279,1001,64,1,64,1106,0,291,1002,64,2,64,109,-16,21108,41,40,-3,1005,1012,311,1001,64,1,64,1105,1,313,4,297,1002,64,2,64,109,-13,2101,0,2,63,1008,63,30,63,1005,63,335,4,319,1105,1,339,1001,64,1,64,1002,64,2,64,109,-3,2102,1,4,63,1008,63,35,63,1005,63,359,1106,0,365,4,345,1001,64,1,64,1002,64,2,64,109,15,1205,6,377,1105,1,383,4,371,1001,64,1,64,1002,64,2,64,109,5,21102,42,1,-2,1008,1017,39,63,1005,63,403,1106,0,409,4,389,1001,64,1,64,1002,64,2,64,109,-17,21107,43,44,10,1005,1012,431,4,415,1001,64,1,64,1106,0,431,1002,64,2,64,109,14,21107,44,43,-4,1005,1012,451,1001,64,1,64,1106,0,453,4,437,1002,64,2,64,109,1,21102,45,1,-3,1008,1014,45,63,1005,63,479,4,459,1001,64,1,64,1105,1,479,1002,64,2,64,109,7,2105,1,0,4,485,1106,0,497,1001,64,1,64,1002,64,2,64,109,5,1206,-8,513,1001,64,1,64,1106,0,515,4,503,1002,64,2,64,109,-33,2101,0,7,63,1008,63,32,63,1005,63,535,1106,0,541,4,521,1001,64,1,64,1002,64,2,64,109,23,2106,0,8,1001,64,1,64,1106,0,559,4,547,1002,64,2,64,109,-1,21101,46,0,-5,1008,1013,46,63,1005,63,585,4,565,1001,64,1,64,1105,1,585,1002,64,2,64,109,-4,21101,47,0,2,1008,1016,44,63,1005,63,605,1105,1,611,4,591,1001,64,1,64,1002,64,2,64,109,-18,1207,4,38,63,1005,63,627,1106,0,633,4,617,1001,64,1,64,1002,64,2,64,109,5,2107,22,7,63,1005,63,649,1106,0,655,4,639,1001,64,1,64,1002,64,2,64,109,12,2105,1,10,1001,64,1,64,1106,0,673,4,661,1002,64,2,64,109,-10,1208,6,33,63,1005,63,693,1001,64,1,64,1106,0,695,4,679,1002,64,2,64,109,-7,2108,35,7,63,1005,63,715,1001,64,1,64,1106,0,717,4,701,1002,64,2,64,109,6,1208,5,37,63,1005,63,735,4,723,1106,0,739,1001,64,1,64,1002,64,2,64,109,-4,1202,5,1,63,1008,63,34,63,1005,63,765,4,745,1001,64,1,64,1105,1,765,1002,64,2,64,109,29,1206,-7,783,4,771,1001,64,1,64,1105,1,783,1002,64,2,64,109,-28,1201,6,0,63,1008,63,29,63,1005,63,809,4,789,1001,64,1,64,1106,0,809,1002,64,2,64,109,5,1202,2,1,63,1008,63,20,63,1005,63,829,1106,0,835,4,815,1001,64,1,64,1002,64,2,64,109,-1,1201,6,0,63,1008,63,35,63,1005,63,859,1001,64,1,64,1105,1,861,4,841,1002,64,2,64,109,2,1207,-3,25,63,1005,63,879,4,867,1105,1,883,1001,64,1,64,1002,64,2,64,109,13,1205,3,901,4,889,1001,64,1,64,1106,0,901,4,64,99,21101,0,27,1,21101,915,0,0,1106,0,922,21201,1,22987,1,204,1,99,109,3,1207,-2,3,63,1005,63,964,21201,-2,-1,1,21101,0,942,0,1106,0,922,22101,0,1,-1,21201,-2,-3,1,21101,0,957,0,1106,0,922,22201,1,-1,-2,1105,1,968,21202,-2,1,-2,109,-3,2105,1,0].freeze

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

  def parameter_modes_english
    @parameter_modes.map do |mode|
      case mode
      when 0
        'position'
      when 1
        'immediate'
      when 2
        'relative'
      end
    end
  end
end

class Computer
  class Halted < StandardError; end

  OPCODES = {
    1 =>  { command: :add,                  instruction_length: 4 },
    2 =>  { command: :multiply,             instruction_length: 4 },
    3 =>  { command: :save,                 instruction_length: 2 },
    4 =>  { command: :output,               instruction_length: 2 },
    5 =>  { command: :jump_if_true,         instruction_length: 3 },
    6 =>  { command: :jump_if_false,        instruction_length: 3 },
    7 =>  { command: :less_than,            instruction_length: 4 },
    8 =>  { command: :equals,               instruction_length: 4 },
    9 =>  { command: :adjust_relative_base, instruction_length: 2 },
    99 => { command: :halt,                 instruction_length: 1 }
  }.freeze

  def initialize(computer_id, program, inputs)
    @computer_id = computer_id
    @memory = program.dup
    @inputs = inputs
    @instruction_ptr = 0
    @has_halted = false
    @relative_base = 0
  end

  def set_debug(debug)
    @debug = debug
    self
  end

  def add_input(input)
    puts "Computer #{@computer_id}: Adding input #{input}" if @debug
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
      @memory[parameter] || 0
    when 1
      parameter
    when 2
      @memory[@relative_base + parameter] || 0
    end
  end

  def get_output_address(instruction, parameter_position)
    parameter = instruction.parameter(parameter_position)
    parameter_mode = instruction.parameter_mode(parameter_position)
    case parameter_mode
    when 0
      parameter
    when 1
      raise 'Parameters that an instruction writes to will never be in immediate mode.'
    when 2
      @relative_base + parameter
    end
  end

  def execute_instruction(instruction)
    instruction_ptr_modified = false
    return_value = nil
    puts "\n#{@computer_id}: executing instruction ..." if @debug
    puts "\tAddress:\t#{@instruction_ptr}" if @debug
    puts "\tInstruction:\t#{instruction.opcode}: #{instruction.command}" if @debug
    puts "\tParam modes:\t#{instruction.parameter_modes_english}" if @debug
    puts "\tParameters\t#{instruction.parameters}" if @debug
    case instruction.command
    when :add
      operand1 = get_operand(instruction, 0)
      operand2 = get_operand(instruction, 1)
      output_address = get_output_address(instruction, 2)
      @memory[output_address] = operand1 + operand2
      puts "\t@memory[#{output_address}] = #{operand1} + #{operand2} = #{operand1 + operand2}" if @debug
    when :multiply
      operand1 = get_operand(instruction, 0)
      operand2 = get_operand(instruction, 1)
      output_address = get_output_address(instruction, 2)
      @memory[output_address] = operand1 * operand2
      puts "\t@memory[#{output_address}] = #{operand1} * #{operand2} = #{operand1 * operand2}" if @debug
    when :save
      output_address = get_output_address(instruction, 0)
      input = @inputs.shift
      raise 'INPUT IS NIL' unless input
      @memory[output_address] = input
      puts "\t@memory[#{output_address}] = #{input}" if @debug
    when :output
      operand1 = get_operand(instruction, 0)
      puts "\tOutputting #{operand1}"
      return_value = operand1
    when :jump_if_true
      do_jump = get_operand(instruction, 0) != 0
      if do_jump
        @instruction_ptr = get_operand(instruction, 1)
        puts "\ttrue, so jumping to #{@instruction_ptr}" if @debug
        instruction_ptr_modified = true
      else
        puts "\tfalse, so not jumping" if @debug
      end
    when :jump_if_false
      do_jump = get_operand(instruction, 0) == 0
      if do_jump
        @instruction_ptr = get_operand(instruction, 1) 
        puts "\tfalse, so jumping to #{@instruction_ptr}" if @debug
        instruction_ptr_modified = true
      else
        puts "\ttrue, so not jumping" if @debug
      end
    when :less_than
      operand1 = get_operand(instruction, 0)
      operand2 = get_operand(instruction, 1)
      output_address = get_output_address(instruction, 2)
      @memory[output_address] = operand1 < operand2 ? 1 : 0
      puts "\tchecking if #{operand1} < #{operand2}" if @debug
      puts "\tresult: @memory[#{output_address}] = #{@memory[output_address]}" if @debug
    when :equals
      operand1 = get_operand(instruction, 0)
      operand2 = get_operand(instruction, 1)
      output_address = get_output_address(instruction, 2)
      @memory[output_address] = operand1 == operand2 ? 1 : 0
      puts "\tchecking if #{operand1} == #{operand2}" if @debug
      puts "\tresult: @memory[#{output_address}] = #{@memory[output_address]}" if @debug
    when :adjust_relative_base
      operand1 = get_operand(instruction, 0)
      puts "\tadjust_relative_base: old = #{@relative_base}, new = #{@relative_base + operand1}" if @debug
      @relative_base += operand1
    end
    @instruction_ptr += instruction.length unless instruction_ptr_modified
    return_value
  end

  def execute_program
    raise 'Computer has halted' if @has_halted
    loop do
      instruction = parse_instruction()
      if instruction.command == :halt
        puts "Computer #{@computer_id}: Halting" if @debug
        @has_halted = true
        return { status: :halted }
      end
      output = execute_instruction(instruction)
      # return { status: :output, output_value: output } if output
    end
  end

  def print_memory
    @memory.each_with_index { |val, i| puts "#{i}\t#{val}"}
  end
end

# Part 1 - Tests
# Computer.new('test 1', TEST_1, [0]).set_debug(true).execute_program
# Computer.new('test 2', TEST_2, [0]).execute_program
# Computer.new('test 3', TEST_3, [0]).execute_program

# Part 1 - Execute
computer = Computer.new('main program', MAIN_PROGRAM, [1])#.set_debug(true)
# computer.print_memory
computer.execute_program
# 2518058886

# Part 2 - Execute
Computer.new('main program', MAIN_PROGRAM, [2]).execute_program
# 44292
