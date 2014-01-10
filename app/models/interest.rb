class Interest
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::MassAssignmentSecurity

  attr_accessor :label, :weight, :activities_size, :activities_id
  attr_accessible :label, :weight, :activities_size, :activities_id

  def initialize(json)
    self.label  = json['label']
    self.weight = json['weight']
    self.activities_size = json['activitiesSize']
    self.activities_id = json['activities']
  end

  def weight_f
    self.weight == "NaN" ? 0 : format('%.6f', self.weight).to_f
  end
end
