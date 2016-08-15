class StocksPdf < Prawn::Document
  TABLE_WIDTHS = [80, 50, 250, 80, 80, 110]
  def initialize(stocks, from_date, to_date, view_context)
    super(margin: 20, page_size: [612, 1008], page_layout: :portrait)
    @stocks = stocks
    @from_date = from_date
    @to_date = to_date
    @view_context = view_context
    heading
    display_stocks_table

  end
  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end
  def heading
    text 'Stock Report', size: 12, align: :center
    text "#{@from_date.strftime("%B %e, %Y")}", size: 10
    text "#{@to_date.strftime("%B %e, %Y")}", size: 10
    text "#{@stocks.count}"
    text "#{price(@stocks.total_cost_of_purchase)}"


  end
  def display_stocks_table
    if @stocks.blank?
      move_down 10
      text "No stocks data.", align: :center
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
    @table_data ||= @stocks.map { |e| [e.date.strftime('%B %e, %Y'), e.quantity, e.name, price(e.unit_price), price(e.purchase_price)]}
  end
end
