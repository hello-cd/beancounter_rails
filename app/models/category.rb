class Category
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::MassAssignmentSecurity

  attr_accessor :label, :weight
  attr_accessible :label, :weight

  def initialize(json)
    self.label  = json['label']
    self.weight = json['weight']
  end
end

