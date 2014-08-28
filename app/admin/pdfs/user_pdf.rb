# require 'prawn/table'

# class OrderPdf < Prawn::Document
#   def initialize(user)
#     super(top_margin: 70)
#     @user = user
#     current_date
#     user_name
#     line_items
#     company_name
#   end

#   def user_name
#   	move_down 20
#     random = SecureRandom.hex(4).upcase
#     text "#{ @user.id }#{ random }", size: 24, style: :bold, align: :center
#   end

#   def current_date
#   	text Time.now.to_formatted_s(:long_ordinal), align: :right
#   end

#   def line_items
#   	@user.security_codes[0..11].each_with_index do |code, index|
#   		text "#{index + 1} - #{code}"
#   	end

#     # @user.security_codes.in_groups_of(12, false).each_with_index do |codes, top_index|
#     # 	codes.each_with_index do |code, index|
#     # 		"#{ (index + 1) + (top_index * 12) }" ":" "#{ code }"
#     # 	end
#     # end
#   end

#   def company_name
#     move_down 100
#     text "WuDii", align: :center, size: 32
#     move_down 50
#     text "Sid Ideas", align: :center, size: 18
#     move_down 15
#     text "www.sidideas.com", align: :center, size: 16
#     move_down 85
#     text "WuDii © #{ Time.now.year }", align: :center, style: :bold, size: 10
#   end
# end