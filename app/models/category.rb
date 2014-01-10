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

  def weight_f
    self.weight == "NaN" ? 0 : format('%.6f', self.weight).to_f
  end
end

