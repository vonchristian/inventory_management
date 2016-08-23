module Members
  class LineItemsPdf < Prawn::Document
    TABLE_WIDTHS = [80, 50, 140, 80, 80, 100]
    def initialize(member, line_items, from_date, to_date, view_context)
      super(margin: 40, page_size: [612, 1008], page_layout: :portrait)
      @member = member
      @line_items = line_items
      @from_date = from_date
      @to_date = to_date
      @view_context = view_context
      heading
      display_cash_line_items_table
      display_credit_line_items_table


    end
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end
    def heading




      text "MEMBER'S TRANSACTION REPORT", size: 12, align: :center, style: :bold
      stroke_horizontal_rule
      move_down 10
      text "#{@member.full_name.upcase}", size: 12
      text "#{Business.last.try(:proprietor)}", size: 10
      text "#{Business.last.try(:tin)}", size: 10
      text "#{Business.last.try(:address)}", size: 10
      move_down 10
      move_down 10
      text 'SUMMARY:', style: :bold
      move_down 5
      text "FROM DATE:                              #{@from_date.strftime("%B %e, %Y")}", size: 10
      move_down 5
      text "TO DATE:                                    #{@to_date.strftime("%B %e, %Y")}", size: 10
      move_down 5
      text "CASH TRANSACTION:                      #{price(@member.line_items.sum(:unit_cost))}", size: 10, style: :bold
      text "CREDIT TRANSACTION:                      #{price(@member.line_items.sum(:unit_cost))}", size: 10, style: :bold





      move_down 3
      stroke_horizontal_rule


    end
    def display_cash_line_items_table
      if @line_items.blank?
        move_down 10
        text "No orders data.", align: :center
      else
        move_down 10
        text "CASH TRANSACTIONS", size: 10, style: :bold
        table(cash_data, header: true, cell_style: { size: 8, font: "Helvetica"}, column_widths: TABLE_WIDTHS) do
          row(0).font_style = :bold
        # /  row(0).background_color = 'DDDDDD'
          column(4).align = :right
          column(5).align = :right

        end
      end
    end

    def cash_data
      move_down 5
      [["DATE", "QTY", "PRODUCT",  "SERIAL", "PRICE", "AMOUNT"]] +
      @cash_data ||= @member.line_items.cash.map { |e| [e.created_at.strftime("%B %e, %Y %I:%M %p"), e.quantity, e.stock.try(:name), e.stock.try(:serial_number), e.unit_cost, e.total_cost]}
    end

  def display_credit_line_items_table
    if @member.line_items.credit.blank?
      move_down 20
      text "CREDIT TRANSACTIONS", size: 10, style: :bold
      text "No credit data."
    else
      move_down 10
      text "CREDIT TRANSACTIONS", size: 10, style: :bold
      table(credit_data, header: true, cell_style: { size: 8, font: "Helvetica"}, column_widths: TABLE_WIDTHS) do
        row(0).font_style = :bold
      # /  row(0).background_color = 'DDDDDD'
        column(4).align = :right
        column(5).align = :right

      end
    end
  end

  def credit_data
    move_down 5
    [["DATE", "QTY", "PRODUCT",  "SERIAL", "PRICE", "AMOUNT"]] +
    @credit_data ||= @member.line_items.credit.map { |e| [e.created_at.strftime("%B %e, %Y %I:%M %p"), e.quantity, e.stock.try(:name), e.stock.try(:serial_number), e.unit_cost, e.total_cost]}
  end
end
end
