class FinMessageReference < ApplicationRecord
  belongs_to :fin_message
  belongs_to :referenced_entity, polymorphic: true
end
