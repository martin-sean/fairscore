require 'test_helper'
require UserRatingMaths

class MyTest < ActiveSupport::TestCase

  def setup
    @delta = 0.05
  end

  def teardown
  end

  test 'should calculate mean (integer)' do
    sum = 5 + 2 + 1 + 7
    n = 5
    assert_equal(3, calc_mean(sum, n))
  end

  test 'should calculate mean (float)' do
    sum = 3 + 10 + 5 + 2
    n = 3
    assert((6.67 - calc_mean(sum, n)).abs <= @delta)
  end

  test 'should calculate standard deviation' do
    sum = 8 + 2 + 4 + 1
    sum_sq = 64 + 4 + 16 + 1
    n = 4
    assert((2.68 - calc_std_dev(sum, sum_sq, n)).abs <= @delta)
  end

  test 'should calculate z-score' do
    value = 8
    sum = 3 + 5 + 7
    sum_sq = 9 + 25 + 49
    n = 3
    assert((1.84 - calc_z_score(value, sum, sum_sq, n)).abs <= @delta)
  end
end