require 'test_helper'

class AttributeTest < ActiveSupport::TestCase

  test 'array' do
    product = Product.new
    assert_equal '', product.size_list

    product.expects(:size_added).never
    product.expects(:size_removed).never
    product.sizes << '64GB'
    assert_equal '64GB', product.size_list
    assert_equal ['64GB'], product.sizes
    assert_equal [], product.added_sizes_to_list
    assert_equal [], product.removed_sizes_from_list

    product.expects(:size_added).once.with('32GB')
    product.expects(:size_removed).once.with('64GB')
    product.size_list = '32GB'
    assert_equal '32GB', product.size_list
    assert_equal ['32GB'], product.sizes
    assert_equal ['32GB'], product.added_sizes_to_list
    assert_equal ['64GB'], product.removed_sizes_from_list
  end

end
