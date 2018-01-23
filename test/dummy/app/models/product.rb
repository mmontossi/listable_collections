class Product < ActiveRecord::Base

  has_many :tagizations
  has_many :tags, through: :tagizations

  listify :sizes, after_add: :size_added, after_remove: :size_removed
  listify :tags, by: :name

  serialize :sizes, Array

  def size_added(size)
  end

  def size_removed(size)
  end

end
