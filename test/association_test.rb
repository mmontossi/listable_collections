require 'test_helper'

class AssociationTest < ActiveSupport::TestCase

  test 'has many through' do
    product = Product.create
    product.tags.create name: 'Natural'
    assert_equal 'Natural', product.tag_list

    sale = Tag.new(name: 'New')
    product.tags << sale
    assert_equal 'Natural,New', product.tag_list
    added_tag_names = product.tagizations.reject(&:marked_for_destruction?).map(&:tag).map(&:name)
    assert_equal ['Natural', 'New'], added_tag_names
    removed_tag_names = product.tagizations.select(&:marked_for_destruction?).map(&:tag).map(&:name)
    assert_equal [], removed_tag_names
    assert_equal [], product.added_tags_to_list
    assert_equal [], product.removed_tags_from_list

    product.tag_list = 'Light'
    assert_equal 'Light', product.tag_list
    added_tag_names = product.tagizations.reject(&:marked_for_destruction?).map(&:tag).map(&:name)
    assert_equal ['Light'], added_tag_names
    removed_tag_names = product.tagizations.select(&:marked_for_destruction?).map(&:tag).map(&:name)
    assert_equal ['Natural', 'New'], removed_tag_names
    assert_equal ['Light'],  product.added_tags_to_list
    assert_equal ['Natural', 'New'], product.removed_tags_from_list
  end

end
