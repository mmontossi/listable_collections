require 'test_helper'

class AttributeTest < ActiveSupport::TestCase

  test 'accessor' do
    iphone = products(:iphone)
    assert_equal '', iphone.size_list

    iphone.expects(:size_added).never
    iphone.expects(:size_removed).never
    iphone.sizes << '64GB'
    assert_equal '64GB', iphone.size_list
    assert_equal [], iphone.added_sizes_to_list
    assert_equal [], iphone.removed_sizes_from_list

    iphone.expects(:size_added).once.with('32GB')
    iphone.expects(:size_removed).once.with('64GB')
    iphone.size_list = '32GB'
    assert_equal '32GB', iphone.size_list
    assert_equal ['32GB'], iphone.added_sizes_to_list
    assert_equal ['64GB'], iphone.removed_sizes_from_list
  end

end
