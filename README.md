[![Gem Version](https://badge.fury.io/rb/listable_collections.svg)](http://badge.fury.io/rb/listable_collections)
[![Code Climate](https://codeclimate.com/github/museways/listable_collections/badges/gpa.svg)](https://codeclimate.com/github/museways/listable_collections)
[![Build Status](https://travis-ci.org/museways/listable_collections.svg)](https://travis-ci.org/museways/listable_collections)
[![Dependency Status](https://gemnasium.com/museways/listable_collections.svg)](https://gemnasium.com/museways/listable_collections)

# Listable collections

Makes collections accessible from a string list in rails.

## Why

We did this gem to:

- Easily manage collections from input text field.
- Track changes like dirty module in activerecord.
- Have callbacks like has_many associations.
- Automatically handle join models creation/deletion.

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
class Product < ApplicationRecord

  has_many :tagizations
  has_many :tags, through: :tagizations

  listify :tags, by: :name

end
```

Associated records will be synced and chances will be tracked using the following helpers:
```ruby
product.tags.map(&:name) => ['New']
product.tag_list => 'New'

product.tag_list = 'Natural'
product.tagizations.reject(&:marked_for_destruction?).map(&:tag).map(&:name) => ['Natural']
product.tagizations.select(&:marked_for_destruction?).map(&:tag).map(&:name) => ['New']

product.added_tags_to_list => ['Natural']
product.removed_tags_from_list => ['New']
```

NOTE: All associations are assumed to be has many through to be able to handle creations/deletions.

### Attributes

If you want to list an array attribute:
```ruby
class Product < ActiveRecord::Base

  serialize :sizes, Array

  listify :sizes

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
class Product < ActiveRecord::Base

  serialize :sizes, Array

  listify :sizes, after_add: :size_added, after_remove: :size_removed

  def size_added(name)
    # Some logic
  end

  def size_removed(name)
    # Some logic
  end

end
```

## Contributing

Any issue, pull request, comment of any kind is more than welcome!

We will mainly ensure compatibility to Rails, AWS, PostgreSQL, Redis, Elasticsearch and FreeBSD. 

## Credits

This gem is maintained and funded by [museways](https://github.com/museways).

## License

It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
