FactoryBot.define do
  factory :product do
    product_id { SecureRandom.uuid }
    product_name { "Product #{rand(1..100)}" }
    product_category_id { rand(1..10) }
    brand { "Brand #{rand(1..5)}" }
    shop_name { "Shop #{rand(1..5)}" }
    country { ["US", "UK", "FR", "DE", "NL"].sample }
    price { rand(10.0..100.0).round(2) }
    url { "https://example.com/product/#{SecureRandom.hex}" }
  end
end
