require 'test_helper'

class AssociationTest < ActiveSupport::TestCase

  test 'accessor' do
    apple = shops(:apple)
    assert_equal 'iPhone,iPad', apple.product_list

    imac = Product.new(name: 'iMac')
    apple.expects(:product_added).never
    apple.expects(:product_removed).never
    apple.products << imac
    assert_equal 'iPhone,iPad,iMac', apple.product_list
    assert_equal [], apple.added_products_to_list
    assert_equal [], apple.removed_products_from_list

    apple.expects(:product_added).once.with('MacBook')
    apple.expects(:product_removed).once.with('iPad')
    apple.product_list = 'iMac,iPhone,MacBook'
    assert_equal 'iMac,iPhone,MacBook', apple.product_list
    assert_equal ['MacBook'], apple.added_products_to_list
    assert_equal ['iPad'], apple.removed_products_from_list
  end

end
