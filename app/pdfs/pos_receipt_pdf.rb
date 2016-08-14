require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'
class PosReceiptPdf < Prawn::Document
  TABLE_WIDTHS = [25, 60, 50]
  def initialize(order, line_items, view_context)
    @order = order
    @line_items = line_items
    @view_context = view_context
    # line_height = 14
    # min_height = 419.53
    # variable_height = y_position * line_height
    # height = min_height + variable_height
    super(margin: 10, page_size: [160, :auto], page_layout: :portrait)

    heading
    customer_details
    order_details
    payment_details
    barcode
    footer_for_receipt
    last_character

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
def barcode
  barcode = Barby::Code39.new @order.reference_number
  barcode.annotate_pdf(self, height: 10)
end
def footer_for_receipt
  text "<b>#{@order.employee.try(:full_name).upcase}</b>", size: 6, align: :center, inline_format: true
  text "Sales Person", size: 6, align: :center
  move_down 5
  text "#{@order.reference_number}", size: 6, align: :center
  move_down 3
  text "THIS SERVES AS AN OFFICIAL RECEIPT", size: 6, align: :center
  text "MACHINE ACCREDITATION : #{@order.machine_accreditation}", size: 4, align: :center
  move_down 10
end
def last_character
  bounding_box([(bounds.left + 5), bounds.top - 130], width: 750) do
          font_size(10)
          text_box "#{@order.reference_number * 100}", inline_format: :true, :at => [bounds.left + 10, bounds.top - 10]
          stroke_bounds do
            rectangle [0, 0],  760, :height => :auto  # ===> I need this height auto
          end
        end
end
end
