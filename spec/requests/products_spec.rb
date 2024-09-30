# spec/requests/products_spec.rb
require 'rails_helper'

RSpec.describe "Products API", type: :request do
  let!(:product1) { create(:product, country: 'US', product_name: 'Product 1') }
  let!(:product2) { create(:product, country: 'UK', product_name: 'Product 2') }

  describe "GET /products" do
    context "when no filter is applied" do
      it "returns a successful response" do
        get "/products"
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["products"].count).to eq(2)
      end

      it "returns all products" do
        get "/products"
        json_response = JSON.parse(response.body)
        expect(json_response["products"].count).to eq(2)
        expect(json_response["products"].map { |p| p["product_name"] }).to include("Product 1", "Product 2")
      end
    end

    context "when filtered by country" do
      it "returns only products from the specified country" do
        get "/products", params: { country: 'US' }
        json_response = JSON.parse(response.body)
        expect(json_response["products"].count).to eq(1)
        expect(json_response["products"].first["country"]).to eq("US")
      end
    end

    context "when filtered by product_name" do
      it "returns only products with the specified product_name" do
        get "/products", params: { product_name: 'Product 1' }
        json_response = JSON.parse(response.body)
        expect(json_response["products"].count).to eq(1)
        expect(json_response["products"].first["product_name"]).to eq("Product 1")
      end
    end
  end
end
