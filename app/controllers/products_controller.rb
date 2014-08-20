class ProductsController < ApplicationController
	before_action :set_product, only: [:show, :edit, :update, :destroy]
	before_action :set_vendor, only: [:index, :new]

	def index
		@products = @vendor.products.limit(10)
	end

	def show
		@vendor = @product.vendor
	end

	def new
		@product = Product.new
	end

	def edit
	end

	def create
		@vendor  = current_vendor
		@product = @vendor.products.new(product_params)
		respond_to do |format|
			if @product.save
				format.html { redirect_to @product }
        format.json { render action: 'show', status: :created, location: @product }
			else
				format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
			end
		end		
	end

	def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_path(@product) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to current_vendor }
      format.json { head :no_content }
      format.js
    end
  end

	private

		def product_params
			params.require(:product).permit(:name, :credits, :image, 
																			:image_remote_url, :delete_image)
		end

		def set_product
			@product = Product.find(params[:id])
		end

		def set_vendor
			@vendor = Vendor.find(params[:vendor_id])
		end
end
