[![Gem Version](https://badge.fury.io/rb/listable_collections.svg)](http://badge.fury.io/rb/listable_collections)
[![Code Climate](https://codeclimate.com/github/mmontossi/listable_collections/badges/gpa.svg)](https://codeclimate.com/github/mmontossi/listable_collections)
[![Build Status](https://travis-ci.org/mmontossi/listable_collections.svg)](https://travis-ci.org/mmontossi/listable_collections)
[![Dependency Status](https://gemnasium.com/mmontossi/listable_collections.svg)](https://gemnasium.com/mmontossi/listable_collections)

# Listable collections

Makes collections accessible from a string list in rails.

## Why

I did this gem to:

- Easily manage collections from input text field.
- Track changes like dirty module in activerecord.
- Have callbacks like has_many associations.

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

### Associations

If you want to list a has_many association:
```ruby
class Shop < ActiveRecord::Base

  has_many :products

  list :products, attribute: :name

end
```

Associated records won't be touched but changes will be tracked using the following helpers:
```ruby
shop.products.map(&:name) => ['iPhone']
shop.product_list => 'iPhone'

shop.product_list = 'iPod,iMac'
shop.products.map(&:name) => ['iPhone']

shop.added_products_to_list => ['iMac']
shop.removed_products_from_list => ['iPod']
```

NOTE: Is recommended to do this check before save all at once and not dynamically to avoid multiple queries.

### Attributes

If you want to list an array attribute:
```ruby
class Product < ActiveRecord::Base

  serialize :sizes, Array

  list :sizes

end
```

The attribute will be synced and chances will be tracked using the following helpers:
```ruby
product.sizes => ['64GB']
product.size_list => '64GB'

product.size_list = '32GB,128GB'
product.sizes => ['32GB','128GB']

product.added_sizes_to_list => ['128GB']
product.removed_sizes_from_list => ['64GB']
```

In some cases you may need to run some logic after changes, you can use callbacks for it:
```ruby
class Shop < ActiveRecord::Base

  has_many :product

  list :products, attribute: :name, after_add: :product_added, after_remove: :product_removed

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
