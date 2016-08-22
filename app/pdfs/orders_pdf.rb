class OrdersPdf < Prawn::Document
  TABLE_WIDTHS = [80, 50, 180, 80, 80, 100]
  def initialize(line_items, from_date, to_date, view_context)
    super(margin: 20, page_size: [612, 1008], page_layout: :portrait)
    @line_items = line_items
    @from_date = from_date
    @to_date = to_date
    @view_context = view_context
    heading
    display_orders_table

  end
  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end
  def heading
    text "#{Business.last.try(:name)}", size: 8
    text "#{Business.last.try(:proprietor)}", size: 8
    text "#{Business.last.try(:tin)}", size: 8
    text "#{Business.last.try(:address)}", size: 8



    text 'SALES REPORT', size: 12, align: :center, style: :bold
    text "FROM DATE:                              #{@from_date.strftime("%B %e, %Y")}", size: 9
    move_down 2
    text "TO DATE:                                    #{@to_date.strftime("%B %e, %Y")}", size: 9
    move_down 2
    text "TOTAL SALES:                      #{price(@line_items.created_between(@from_date, @to_date).sum(:total_cost))}", size: 12, style: :bold




    move_down 3
    stroke_horizontal_rule


  end
  def display_orders_table
    if @line_items.blank?
      move_down 10
      text "No orders data.", align: :center
    else
      move_down 10

      table(table_data, header: true, cell_style: { size: 8, font: "Helvetica"}, column_widths: TABLE_WIDTHS) do
        row(0).font_style = :bold
      # /  row(0).background_color = 'DDDDDD'
        column(4).align = :right
        column(5).align = :right

      end
    end
  end

  def table_data
    move_down 5
    [["DATE", "QTY", "PRODUCT",  "SERIAL", "PRICE", "AMOUNT"]] +
    @table_data ||= @line_items.map { |e| [e.created_at.strftime("%B %e, %Y %I:%M %p"), e.quantity, e.stock.try(:name), e.stock.try(:serial_number), e.unit_cost, e.total_cost]}
  end
end
