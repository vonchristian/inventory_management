class ProductsPdf < Prawn::Document
  TABLE_WIDTHS = [170, 80, 80, 80, 80, 80]
  def initialize(products, view_context)
    super(margin: 20, page_size: [612, 1008], page_layout: :portrait)
    @products = products
    @view_context = view_context
    heading
    display_products_table

  end
  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end
  def heading
    text 'Products Report', size: 12, align: :center
    move_down 5
    text "As of " + Date.today.strftime("%B %e, %Y"), size: 10, align: :center
  end
  def display_products_table
    if @products.blank?
      move_down 10
      text "No products data.", align: :center
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
    [["NAME", "PRICE", "WHOLESALE PRICE", "IN STOCK", "UNIT", "STOCK ALERT"]] +
    @table_data ||= @products.map { |e| [e.name, price(e.stocks.last.retail_price), price(e.stocks.last.wholesale_price), e.stocks.last.in_stock, e.unit, e.stock_status.titleize]}
  end
end
