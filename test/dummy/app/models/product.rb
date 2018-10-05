class Product < ActiveRecord::Base

  has_many :tagizations
  has_many :tags, through: :tagizations
  has_many :vendors, dependent: :destroy

  listize :sizes
  listize :tags, by: :name
  listize :vendors, by: :name

  serialize :sizes, Array

end
