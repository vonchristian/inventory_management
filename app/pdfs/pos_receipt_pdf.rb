class PosReceiptPdf < Prawn::Document
  TABLE_WIDTHS = [25, 60, 50]
  def initialize(order, line_items, view_context)
    super(margin: 10, page_size: [160, 500], page_layout: :portrait)
    @order = order
    @line_items = line_items
    @view_context = view_context
    heading
    customer_details
    order_details
    payment_details
    footer_for_receipt
  end
  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end
  def heading
    y_position = cursor
    font  "Helvetica"
    move_down 30
    text "<b>OFFICIAL RECEIPT</b>", size: 6, inline_format: true, align: :center
    text "<b># #{@order.reference_number}</b>", size: 6, inline_format: true, align: :center

    move_down 4
    image "#{Business.last.logo.path(:medium)}", height: 25, width: 25, at: [60, y_position]
    move_down 5
    text "<b>#{Business.last.try(:name)}</b>", size: 6, inline_format: true
    text "Proprietor: #{Business.last.try(:proprietor)}", size: 6, inline_format: true
    text "TIN: #{Business.last.try(:tin)}", size: 6, inline_format: true
    text "Contact #: #{Business.last.try(:mobile_number)}", size: 6, inline_format: true
    text "Email: #{Business.last.try(:email)}", size: 6, inline_format: true
    move_down 3
    stroke_horizontal_rule
    move_down 3
  end
  def customer_details
    text "Sold To: #{@order.member.try(:full_name).upcase}", size: 6, inline_format: true
    text "Address: #{@order.member.try(:address)}", size: 5, inline_format: true
    text "Contact #: #{@order.member.try(:mobile)}", size: 5, inline_format: true
    text "Date: #{@order.date.strftime("%B %e, %Y")}", size: 5, inline_format: true
    move_down 3
    stroke_horizontal_rule
  end
  def order_details
      move_down 5
      table(order_table_data, header: true, cell_style: {:padding => [2, 0, 5, 0], :border_lines => [:dotted],  size: 5, font: "Helvetica"}, column_widths: TABLE_WIDTHS) do
        cells.borders = [:bottom]
        row(0).font_style = :bold
        # row(0).background_color = 'DDDDDD'
        column(2).align = :right
      end

  end

  def order_table_data
    move_down 5
    [["QTY", "DESCRIPTION", "AMOUNT"]] +
    @order_table_data ||= @line_items.map { |e| [e.quantity, e.stock.try(:name), price(e.total_cost)]}
  end
  def payment_details
    move_down 2
    table(payment_table_data, header: true, cell_style: {:padding => [0, 0, 2, 0], size: 5, font: "Helvetica", inline_format: true}, column_widths: TABLE_WIDTHS) do
      cells.borders = []
      column(1).align = :right
      column(2).align = :right
      row(4).padding = [0,0,20,0]
    end
end

def payment_table_data
  move_down 5
  @payment_table_data ||= [["", "SUBTOTAL", "#{price(@order.total_amount)}"]] +
                          [["", "VATABLE AMOUNT", "#{price(@order.vatable_amount)}"]] +
                          [["", "12% VAT", "#{price(@order.vat_percentage)}"]] +
                          [["", "DISCOUNT", "#{price(@order.total_discount)}"]] +
                          [["", "<b>TOTAL</b>", "<b>#{price(@order.total_amount)}</b>"]]


end
def footer_for_receipt
  text "<b>#{@order.employee.try(:full_name).upcase}</b>", size: 6, align: :center, inline_format: true
  text "Sales Person", size: 6, align: :center
  move_down 5
  move_down 15
  text "#{@order.reference_number}", size: 6, align: :center
  move_down 3
  text "THIS SERVES AS AN OFFICIAL RECEIPT", size: 6, align: :center
  text "MACHINE ACCREDITATION : #{@order.machine_accreditation}", size: 4, align: :center
  move_down 10
end
end
