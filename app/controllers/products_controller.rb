class ProductsController < ApplicationController
  def process_file
    file_path = Rails.root.join('lib', 'data', 'data.json')

    file_content = File.read(file_path).encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
    
    begin
      json_data = JSON.parse(file_content)

      json_data.each_slice(500) do |chunk|
        ProcessJsonFileJob.perform_later(chunk)
      end

      render json: { message: "File processing has started" }, status: :ok
    rescue JSON::ParserError => e
      render json: { error: "Invalid JSON format: #{e.message}" }, status: :unprocessable_entity
    end
  end

  def index
    products = Product.all
    products = Product.where(country: params[:country]) if params[:country].present?
    products = Product.where(product_name: params[:product_name]) if params[:product_name].present?

    products = products.paginate(page: params[:page], per_page: 10)

    render json: { 
      products: products,
      current_page: products.current_page,
      total_pages: products.total_pages
    }, status: :ok
  end
end