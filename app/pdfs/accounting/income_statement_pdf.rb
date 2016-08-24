module Accounting
  class IncomeStatementPdf < Prawn::Document

  def initialize(revenues,  expenses, from_date, to_date, view_context)
    super(margin: 20, page_size: [612, 1008], page_layout: :portrait)
    @revenues = revenues
    @expenses = expenses
    @from_date = from_date
    @to_date = to_date
    @view_context = view_context
    heading
    display_revenues
    total_revenues
    display_expenses
    total_expenses
    net_surplus
  end

  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end


  def heading
    text "#{Business.last.try(:name)}", style: :bold, size: 10
  text "#{Business.last.try(:address)}", size: 10
    move_down 10

    text "INCOME STATEMENT", style: :bold, size: 10
    text "#{@from_date.strftime("%B %e, %Y")} - #{@to_date.strftime("%B %e, %Y")}", size: 10
    move_down 5
    stroke_horizontal_rule
    end

    def display_revenues
      move_down 10
      text "REVENUES", size: 11
        table(revenue_data, header: false,  cell_style: { size: 10, font: "Helvetica", :inline_format => true, padding: [0,0,0,0] }, column_widths: [30, 300, 100, 100]) do
       cells.borders = []
      end
    end

    def revenue_data
      move_down 5
      @revenue_data ||= Revenue.all.map { |e| ["", e.name, price(e.balance(from_date: @from_date, to_date: @to_date))]}
    end
       def total_revenues
        move_down 10
        table(total_revenue_data, header: false,  cell_style: { size: 10, font: "Helvetica", :inline_format => true, padding: [0,0,0,0] }, column_widths: [100, 230, 100]) do
       cells.borders = []
        end
      end


    def total_revenue_data
      move_down 5
   @total_revenue_data ||= [["<b>TOTAL REVENUES</b>", "", "<b>#{price(@revenues.balance(from_date: @from_date, to_date: @to_date))}</b>"]]

    end

    def display_expenses
      move_down 10
      text "EXPENSES", size: 11
        table(expense_data, header: false,  cell_style: { size: 10, font: "Helvetica", :inline_format => true, padding: [0,0,0,0] }, column_widths: [30, 300, 100, 100]) do
       cells.borders = []
      end
    end

    def expense_data
      move_down 5
      @expense_data ||= Expense.all.map { |e| ["", e.name, price(e.balance(from_date: @from_date, to_date: @to_date)) ]}
    end
       def total_expenses
        move_down 10
        table(total_expense_data, header: false,  cell_style: { size: 10, font: "Helvetica", :inline_format => true, padding: [0,0,0,0] }, column_widths: [100, 230, 100]) do
       cells.borders = []
        end
      end


    def total_expense_data
      move_down 5

      @total_expense_data ||= [["<b>TOTAL EXPENSES</b>", "", "<b>#{price(@expenses.balance(from_date: @from_date, to_date: @to_date))}</b>"]]

    end

    def net_surplus
       move_down 10

        table(net_surplus_data, header: false,  cell_style: { size: 10, font: "Helvetica", :inline_format => true, padding: [0,0,0,0] }, column_widths: [100, 230, 100]) do
       cells.borders = []
        end
    end
    def net_surplus_data
      @net_surplus_data ||= [["<b>NET SURPLUS</b>", "", "<b>#{price(@revenues.balance(from_date: @from_date, to_date: @to_date) - @expenses.balance(from_date: @from_date, to_date: @to_date))}</b>"]]

    end

  end
end
