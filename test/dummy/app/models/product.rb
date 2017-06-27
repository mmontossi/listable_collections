class Product < ApplicationRecord

  belongs_to :shop

  list :sizes, after_add: :size_added, after_remove: :size_removed

  serialize :sizes, Array

  def size_added(size)
  end

  def size_removed(size)
  end

end
