class OrdersPdf < Prawn::Document
  TABLE_WIDTHS = [80, 180, 100, 100, 100 ]
  def initialize(orders, from_date, to_date, view_context)
    super(margin: 20, page_size: [612, 1008], page_layout: :portrait)
    @orders = orders
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
    move_down 10
    


    move_down 3
    stroke_horizontal_rule


  end
  def display_orders_table
    if @orders.blank?
      move_down 10
      text "No orders data.", align: :center
    else
      move_down 10

      table(table_data, header: true, cell_style: { size: 8, font: "Helvetica"}, column_widths: TABLE_WIDTHS) do
        row(0).font_style = :bold
      # /  row(0).background_color = 'DDDDDD'
        column(2).align = :right
        column(3).align = :right
        column(4).align = :right
        row(-1).font_style = :bold
        row(-1).size = 11




      end
    end
  end

  def table_data
    move_down 5
    [["DATE", "CUSTOMER", "AMOUNT", "DISCOUNT", "PAID AMOUNT"]] +
    @table_data ||= @orders.map { |e| [e.date.strftime("%B %e, %Y %I:%M %p"), e.customer_name, price(e.total_amount), price(e.total_discount), price(e.total_amount_less_discount)]} +
    [["", "", "#{price(@orders.created_between(from_date: @from_date, to_date: @to_date).total_amount)}", "#{price(@orders.created_between(from_date: @from_date, to_date: @to_date).total_discount)}", "#{price(@orders.created_between(from_date: @from_date, to_date: @to_date).total_amount_less_discount)}"]]
  end
end
