class OrdersPdf < Prawn::Document
  TABLE_WIDTHS = [170, 80, 80, 80, 80, 80]
  def initialize(orders, view_context)
    super(margin: 20, page_size: [612, 1008], page_layout: :portrait)
    @orders = orders
    @view_context = view_context
    heading
    display_orders_table

  end
  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end
  def heading
    text 'Order Reports', size: 12, align: :center
  end
  def display_orders_table
    if @orders.blank?
      move_down 10
      text "No orders data.", align: :center
    else
      move_down 10

      table(table_data, header: true, cell_style: { size: 8, font: "Helvetica"}, column_widths: TABLE_WIDTHS) do
        row(0).font_style = :bold
        row(0).background_color = 'DDDDDD'
      end
    end
  end

  def table_data
    move_down 5
    [["DATE", "QTY", "PRODUCT", "PRICE", "AMOUNT"]] +
    @table_data ||= @orders.map { |e| [e.date]}
  end
end
