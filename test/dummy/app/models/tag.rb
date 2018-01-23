class Tag < ApplicationRecord

  has_many :tagizations
  has_many :products, through: :tagizations

end
