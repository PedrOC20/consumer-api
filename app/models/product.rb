# == Schema Information
#
# Table name: products
#
#  id                  :bigint           not null, primary key
#  country             :string(4000)
#  brand               :string(4000)
#  product_id          :integer
#  product_name        :string(4000)
#  shop_name           :string(4000)
#  product_category_id :integer
#  price               :float
#  url                 :string(4000)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Product < ApplicationRecord
  scope :available, -> { where(availability: true) }
  scope :priced_above_zero, -> { where("price > ?", 0) }
end
