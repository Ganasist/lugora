require 'prawn/table'

class OrderPdf < Prawn::Document
  def initialize(user)
    super(top_margin: 70)
    @user = user
    current_date
    user_name
    line_items
    company_name
  end

  def user_name
  	move_down 20
    text "Codes for User ##{ @user.id }", size: 24, style: :bold, align: :center
  end

  def current_date
  	text Time.now.to_formatted_s(:long_ordinal), align: :right
  end

  def line_items
    move_down 20
    table line_item_rows, cell_style: { size: 11, height: 20 }
  end

  def line_item_rows
  	@user.security_codes.in_groups_of(12, false).each do |cell|
  		
  	end
    # @user.security_codes.in_groups_of(12, false).each_with_index do |codes, top_index|
    # 	codes.each_with_index do |code, index|
    # 		"#{ (index + 1) + (top_index * 12) }" ":" "#{ code }"
    # 	end
    # end
  end

  def company_name
    move_down 250
    text "WuDii", align: :center, size: 32
    move_down 50
    text "WuDii © #{ Time.now.year }", align: :center, style: :bold, size: 10
  end
end