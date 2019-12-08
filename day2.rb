#!/usr/bin/env ruby

TEST_PROGRAMS = [
  { program: [1,0,0,0,99], expected_final_memory: [2,0,0,0,99] },
  { program: [2,3,0,3,99], expected_final_memory: [2,3,0,6,99] },
  { program: [2,4,4,5,99,0], expected_final_memory: [2,4,4,5,99,9801] },
  { program: [1,1,1,4,99,5,6,0,99], expected_final_memory: [30,1,1,4,2,5,6,0,99] }
]

MAIN_PROGRAM = [1, 0, 0, 3, 1, 1, 2, 3, 1, 3, 4, 3, 1, 5, 0, 3, 2, 13, 1, 19, 1, 5, 19, 23, 2, 10, 23, 27, 1, 27, 5, 31, 2, 9, 31, 35, 1, 35, 5, 39, 2, 6, 39, 43, 1, 43, 5, 47, 2, 47, 10, 51, 2, 51, 6, 55, 1, 5, 55, 59, 2, 10, 59, 63, 1, 63, 6, 67, 2, 67, 6, 71, 1, 71, 5, 75, 1, 13, 75, 79, 1, 6, 79, 83, 2, 83, 13, 87, 1, 87, 6, 91, 1, 10, 91, 95, 1, 95, 9, 99, 2, 99, 13, 103, 1, 103, 6, 107, 2, 107, 6, 111, 1, 111, 2, 115, 1, 115, 13, 0, 99, 2, 0, 14, 0].freeze

class Computer
  attr_accessor :memory, :default_memory

  OPCODES = {
    1 => :+,
    2 => :*,
    99 => :halt
  }.freeze

  def initialize(program)
    self.default_memory = program.dup
    self.memory = default_memory.dup
  end

  def reset_memory
    self.memory = default_memory.dup
  end

  def get_command(address)
    opcode = memory[address]
    OPCODES[opcode]
  end

  # Execute operation at address, then return new address
  def execute_operation(address)
    command = get_command(address)
    operand1_address = memory[address + 1]
    operand2_address = memory[address + 2]
    output_address = memory[address + 3]
    operand1 = memory[operand1_address]
    operand2 = memory[operand2_address]
    memory[output_address] = operand1.send(command, operand2)
    address + 4
  end

  def execute_program(noun = nil, verb = nil)
    memory[1] = noun if noun
    memory[2] = verb if verb
    instruction_ptr = 0
    loop do
      break if get_command(instruction_ptr) == :halt
      instruction_ptr = execute_operation(instruction_ptr)
    end
    memory[0]
  end

  def memory_matches?(memory_to_compare)
    memory == memory_to_compare
  end
end

# Run test programs
TEST_PROGRAMS.each do |test_case|
  program = test_case[:program]
  expected_final_memory = test_case[:expected_final_memory]
  computer = Computer.new(program)
  computer.execute_program
  unless computer.memory_matches?(expected_final_memory)
    puts "Invalid final memory for program #{test_case[:program]}"
  end
end

# Part 1
computer = Computer.new(MAIN_PROGRAM)
puts computer.execute_program(12, 2)

# Part 2
(0..99).each do |noun|
  (0..99).each do |verb|
    computer.reset_memory
    puts noun * 100 + verb if computer.execute_program(noun, verb) == 19690720
  end
end
