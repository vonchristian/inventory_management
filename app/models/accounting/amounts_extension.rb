module Accounting
  module AmountsExtension
    def balance(hash={})
      if hash[:from_date] && hash[:to_date]
        from_date = hash[:from_date].kind_of?(Date) ? hash[:from_date] : Date.parse(hash[:from_date])
        to_date = hash[:to_date].kind_of?(Date) ? hash[:to_date] : Date.parse(hash[:to_date])
        includes(:entry).where('entries.date' => from_date..to_date).sum(:amount)
      else
        sum(:amount)
      end
    end

    def balance_for_new_record
      balance = BigDecimal.new('0')
      each do |amount_record|
        if amount_record.amount && !amount_record.marked_for_destruction?
          balance += amount_record.amount # unless amount_record.marked_for_destruction?
        end
      end
      return balance
    end
  end
end
