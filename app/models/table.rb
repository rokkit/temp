class Table < ActiveRecord::Base
  # establish_connection :uk_external_development
  # self.table_name = '_reference27'
  belongs_to :lounge
  validates :lounge, :title,  presence: true
end
