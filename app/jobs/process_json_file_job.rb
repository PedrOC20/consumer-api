class ProcessJsonFileJob < ApplicationJob
  queue_as :default

  # Regex pattern to match country codes
  COUNTRY_CODE_REGEX = /\A([A-Z]{2}(?:\s|,)+)+/i

  def perform(json_data)
    json_data.each do |item|
      normalized_data = normalize_item(item)
      insert_product_into_db(normalized_data) if normalized_data
    end
  rescue => e
    logger.error "Error processing JSON: #{e.message}"
  end

  private

  def normalize_item(item)
    # Validate if 'availability' is true and 'price' > 0
    return nil unless item['availability'] && item['price'].to_f > 0

    {
      country: clean_country_or_shop_name(item['country']),
      shop_name: clean_country_or_shop_name(item['ismarketplace'] ? item['marketplaceseller'] : item['site']),
      brand: item['brand'],
      product_id: item['sku'],
      product_name: item['model'],
      product_category_id: item['categoryId'],
      price: item['price'],
      url: item['url']
    }
  end

  def insert_product_into_db(normalized_data)
    Product.create!(
      country: normalized_data[:country],
      brand: normalized_data[:brand],
      product_id: normalized_data[:product_id],
      product_name: normalized_data[:product_name],
      product_category_id: normalized_data[:product_category_id],
      price: normalized_data[:price],
      shop_name: normalized_data[:shop_name],
      url: normalized_data[:url]
    )
  rescue => e
    logger.error "Error inserting product into DB: #{e.message}"
  end

  def clean_country_or_shop_name(value)
    cleaned_value = value.gsub(COUNTRY_CODE_REGEX, '').strip
    cleaned_value.squeeze(' ') # Remove extra spaces
  end
end