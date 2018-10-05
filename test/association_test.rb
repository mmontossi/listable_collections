require 'test_helper'

class AssociationTest < ActiveSupport::TestCase

  test 'through' do
    assert_difference 'Tagization.count', +1 do
      product.new_tag_list = 'Cellphone'
    end
    assert_equal 'Cellphone', product.tag_list

    assert_difference 'Tagization.count', -1 do
      product.tag_ids = []
    end
    assert_equal '', product.tag_list
  end

  test 'regular' do
    assert_difference 'Vendor.count', +1 do
      product.new_vendor_list = 'John'
    end
    assert_equal 'John', product.vendor_list

    assert_difference 'Vendor.count', -1 do
      product.vendor_ids = []
    end
    assert_equal '', product.vendor_list
  end

  private

  def product
    @product ||= Product.create
  end

end
