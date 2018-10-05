require 'test_helper'

class AttributeTest < ActiveSupport::TestCase

  test 'array' do
    product.size_list = '64GB'
    assert_equal '64GB', product.size_list
    assert_equal %w(64GB), product.sizes

    product.size_list = ''
    assert_equal '', product.size_list
    assert_equal [], product.sizes
  end

  private

  def product
    @product ||= Product.create
  end

end
