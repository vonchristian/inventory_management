require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'
class InvoicePdf < Prawn::Document
  TABLE_WIDTHS = [50, 210, 120, 80, 90, 100]
  ORDER_DETAILS_WIDTHS = [200,200, 150]
  def initialize(order, line_items, view_context)
    super(margin: 30, page_size: [612, 792], page_layout: :portrait)
    @order = order
    @line_items = line_items
    @view_context = view_context
    business_details
    barcode
    heading
    customer_details
    display_orders_table
    order_details
    footer_for_warranty
  end
  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end
  def business_details
    table(business_details_data, cell_style: { size: 9, font: "Helvetica", inline_format: true, :padding => [0,0,0,0]}, column_widths: ORDER_DETAILS_WIDTHS) do
        cells.borders = []
        # column(0).background_color = "CCCCCC"
        row(0).font_style = :bold
        row(0).size = 12
        column(2).align = :right


    end
  end
  def business_details_data
      @business_details_data ||=  [["#{Business.last.try(:name)}"]] +
                                  [["TIN   #{Business.last.try(:tin)}", ""]] +
                                  [["Address  #{Business.last.try(:address)}"]] +
                                  [["Contact #"]] +
                                  [["Email #", "",  "No. #{@order.invoice_number.try(:number)}"]]


    end
    def barcode
      bounding_box [420, 690], width: 100 do
        barcode = Barby::Code39.new(@order.invoice_number.number)
        barcode.annotate_pdf(self, height: 40)
      end
    end

  def heading
    move_down 2
    text '<b>SALES INVOICE</b>', size: 14, align: :center, inline_format: true
    move_down 2
    stroke_horizontal_rule
  end
  def customer_details
    table(customer_details_data, cell_style: { :padding => [2,0,0,2], size: 10, font: "Helvetica", inline_format: true}, column_widths: ORDER_DETAILS_WIDTHS) do
        cells.borders = []
        # column(0).background_color = "CCCCCC"
    end
    # stroke_horizontal_rule

  end
  def customer_details_data
    @customer_details_data ||=  [["<b>Sold To:</b>      #{@order.member.try(:full_name)}", "", "<b>Date: </b> #{@order.date.strftime("%B %e, %Y")}"]] +
                                [["<b>Address</b>      #{@order.member.try(:address)}","", "<b>CRM #: </b>"]] +
                                [["<b>Mobile #</b>      #{@order.member.try(:mobile)}", "", "<b>Sold By:</b> #{@order.employee.try(:full_name)}"]]
  end
  def display_orders_table
    if @line_items.blank?
      move_down 10
      text "No orders data.", align: :center
    else
      move_down 10

      table(table_data, header: true, cell_style: { size: 9, font: "Helvetica"}, column_widths: TABLE_WIDTHS) do
        row(0).font_style = :bold
        # row(0).background_color = 'DDDDDD'
        column(0).align = :right
        column(3).align = :right
        column(4).align = :right
        row(0).align = :center
      end
    end
  end

  def table_data
    move_down 5
    [["QTY", "DESCRIPTION", "SERIAL NO.", "UNIT PRICE", "AMOUNT"]] +
    @table_data ||= @line_items.map { |e| [e.quantity, e.stock.try(:name), e.stock.try(:serial_number), price(e.unit_cost), price(e.total_cost)]}
  end

  def order_details
    move_down 20
    table(order_details_data, cell_style: {:padding => [3,0,0,3], size: 10, font: "Helvetica", inline_format: true}, column_widths: ORDER_DETAILS_WIDTHS) do
        cells.borders = []
        # column(0).background_color = "CCCCCC"
        column(1).align = :right
        column(2).align = :right
        row(8).font_style = :bold
        row(8).size = 12


    end
  end
  def order_details_data
      @order_details_data ||= [["Approved By:","ITEMS TOTAL", "#{@line_items.count}"]] +
                              [["_______________________________","Total Sales (VAT Inclusive)", "#{price(@order.total_amount)}"]] +
                              [["","Less: VAT"]] +
                              [["Inspected By:","Amount: Net of VAT"]] +
                              [["_______________________________","Less: SC/PWD Discount"]] +
                              [["Received in Good order and Condition:","Amount Due"]] +
                              [["","Add: VAT"]] +
                              [["_______________________________"]] +
                              [["#{@order.member.try(:full_name)}","TOTAL AMOUNT DUE", "#{price(@order.total_amount)}"]]
  end
  def footer_for_warranty
    bounding_box([10, 80], :width => 500, :height => 110) do
      stroke_horizontal_rule
      move_down 5
  text "Please present this receipt to claim warranty", size: 10, style: :bold, align: :center
  text "<b>WARRANTY:</b>", inline_format: true, size: 8
  text "#{Warranty.last.try(:description)}", size: 8
  end
  bounding_box([10, 5], :width => 500, :height => 110) do
    text '<i>This establsihment is proudly supported by <b>ITWORX POINT-OF- SALE SYSTEM.</b></i>', size: 6, inline_format: true, align: :center
    text 'Developed by <b> ITWORX TECHNOLOGY SERVICES</b> Email us at <b> vc.halip@gmail.com </b> Contact # <b> 0927 4173 271</b>', size: 6, inline_format: true, align: :center
  end
  end
end
