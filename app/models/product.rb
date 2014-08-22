class Product < ActiveRecord::Base
  belongs_to :vendor
  has_many :transactions
  has_many :users, through: :transactions

  validates :name, :credits, :amount_available, :vendor_id, presence: true
  validates :credits, :amount_available, numericality: { only_integer: true, greater_than_or_equal_to: 0  }

	# General image validations
  has_attached_file :image, styles: { default: '500x500>' }, size: { :in => 0..2.megabytes }
	# Validate content type
  validates_attachment_content_type :image, content_type: /\Aimage/
  # Validate filename
  validates_attachment_file_name :image, matches: [/png\Z/, /jpe?g\Z/, /gif\Z/]
  before_validation { image.clear if delete_image == '1' }

  process_in_background :image

  attr_accessor :delete_image
  attr_reader :image_remote_url

  def image_remote_url=(url_value)
     if url_value.present?
      self.image = URI.parse(url_value)
      @image_remote_url = url_value
    end
  end
end
