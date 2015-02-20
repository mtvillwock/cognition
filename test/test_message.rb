require 'minitest/autorun'
require 'cognition'

class CognitionTest < Minitest::Test
  def test_sets_metadata
    msg = Cognition::Message.new('test', user_id: 15, foo: 'bar')
    assert_equal 15, msg.user_id
    assert_equal 'bar', msg.foo
  end
end