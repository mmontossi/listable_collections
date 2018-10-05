class Vendor < ApplicationRecord

  belongs_to :product

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(value)
    self.first_name, self.last_name = value.split
  end

  class << self

    def find_by_name(value)
      find_by(
        "TRIM(COALESCE(vendors.first_name, '') || ' ' || COALESCE(vendors.last_name, '')) = ?",
        value
      )
    end

  end
end
