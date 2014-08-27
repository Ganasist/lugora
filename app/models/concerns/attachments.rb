# Included in User, Vendor, Product
module Attachments
	extend ActiveSupport::Concern
	included do
		attr_accessor :delete_image
	  attr_reader :image_remote_url
	  before_validation { image.clear if delete_image == '1' }
	  # General image validations
	  has_attached_file :image, styles: { original: '500x500>', thumb: '75X75>' },
	  														size: { :in => 0..2.megabytes, message: 'Picture must be under 2 megabytes'  }
		# Validate content type
	  validates_attachment_content_type :image, content_type: /\Aimage/
	  # Validate filename
	  validates_attachment_file_name :image, matches: [/png\Z/, /jpe?g\Z/, /gif\Z/]
	end

	def image_remote_url=(url_value)
     if url_value.present?
      self.image = URI.parse(url_value)
      @image_remote_url = url_value
    end
  end
end