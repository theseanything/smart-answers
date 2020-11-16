require_relative "../test_helper"

module SmartAnswer
  class PostcodeQuestionTest < ActiveSupport::TestCase
    def setup
      @initial_state = State.new(:example)
      @question = Question::Postcode.new(nil, :example) do
        on_response do |response|
          self.my_postcode = response
        end

        next_node { outcome :done }
      end
    end

    test "valid postcode" do
      new_state = @question.transition(@initial_state, "W1A 2AB")
      assert_equal "W1A 2AB", new_state.my_postcode
    end

    test "abnormal postcode" do
      new_state = @question.transition(@initial_state, "w1A2ab")
      assert_equal "W1A 2AB", new_state.my_postcode
    end

    test "incomplete postcode" do
      e = assert_raises InvalidResponse do
        @question.transition(@initial_state, "W1A")
      end
      assert_equal "error_postcode_incomplete", e.message
    end

    test "invalid postcode" do
      e = assert_raises InvalidResponse do
        @question.transition(@initial_state, "invalid-postcode")
      end
      assert_equal "error_postcode_invalid", e.message
    end
  end
end
