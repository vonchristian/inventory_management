class Refund < ApplicationRecord
  belongs_to :entry, class_name: "Accounting::Entry", foreign_key: 'entry_id'
end
