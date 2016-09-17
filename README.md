[![Gem Version](https://badge.fury.io/rb/listable_collections.svg)](http://badge.fury.io/rb/listable_collections)
[![Code Climate](https://codeclimate.com/github/mmontossi/listable_collections/badges/gpa.svg)](https://codeclimate.com/github/mmontossi/listable_collections)
[![Build Status](https://travis-ci.org/mmontossi/listable_collections.svg)](https://travis-ci.org/mmontossi/listable_collections)
[![Dependency Status](https://gemnasium.com/mmontossi/listable_collections.svg)](https://gemnasium.com/mmontossi/listable_collections)

# Listable collections

Makes collections accessible from a string list in rails.

## Install

Put this line in your Gemfile:
```ruby
gem 'listable_collections'
```

Then bundle:
```
$ bundle
```

## Usage

Use "lists" method in your models to define what collections will be listed:

If you want to list an association:
```ruby
class Shop < ActiveRecord::Base
  has_many :products
  lists :products, attribute: :name
end
```

Associated records won't be touched but changes will be tracked using "removed_from_list" and "added_to_list" helpers:
```ruby
shop.products.map(&:name) => ['iPhone']
shop.product_list => 'iPhone'

shop.product_list = 'iPod,iMac'
shop.products.map(&:name) => ['iPhone']

shop.added_products_to_list => ['iMac']
shop.removed_products_from_list => ['iPod']
```

If you want to list an array attribute:
```ruby
class Product < ActiveRecord::Base
  serialize :sizes, Array
  lists :sizes
end
```

The attribute will be synced and chances will be tracked using "removed_from_list" and "added_to_list" helpers:
```ruby
shop.sizes => ['64GB']
shop.size_list => '64GB'

shop.size_list = '32GB,128GB'
shop.sizes => ['32GB','128GB']

shop.added_sizes_to_list => ['128GB']
shop.removed_sizes_from_list => ['64GB']
```

In some cases you may need to run some logic after changes, use the "after_add" and "after_remove" callbacks for it:
```ruby
class Shop < ActiveRecord::Base
  has_many :product
  lists :products, attribute: :name, after_add: :product_added, after_remove: :product_removed
  def product_added(name)
    # Some logic
  end
  def product_removed(name)
    # Some logic
  end
end
```

## Credits

This gem is maintained and funded by [mmontossi](https://github.com/mmontossi).

## License

It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
