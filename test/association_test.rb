require 'test_helper'

class AssociationTest < ActiveSupport::TestCase

  test 'methods' do
    shop = Shop.create
    %w(iPhone iPad).each do |name|
      shop.products.create name: name
    end
    assert_equal 'iPhone,iPad', shop.product_list

    imac = Product.new(name: 'iMac')
    shop.expects(:product_added).never
    shop.expects(:product_removed).never
    shop.products << imac
    assert_equal 'iPhone,iPad,iMac', shop.product_list
    assert_equal [], shop.added_products_to_list
    assert_equal [], shop.removed_products_from_list

    shop.expects(:product_added).once.with('MacBook')
    shop.expects(:product_removed).once.with('iPad')
    shop.product_list = 'iMac,iPhone,MacBook'
    assert_equal 'iPhone,iMac,MacBook', shop.product_list
    assert_equal ['MacBook'], shop.added_products_to_list
    assert_equal ['iPad'], shop.removed_products_from_list
  end

end
