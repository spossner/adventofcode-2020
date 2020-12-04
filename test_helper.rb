require "minitest/autorun"
require "minitest/reporters"
require_relative 'tree_node'
require_relative 'list_node'

MiniTest::Reporters.use!

class TestCase < Minitest::Test
end

