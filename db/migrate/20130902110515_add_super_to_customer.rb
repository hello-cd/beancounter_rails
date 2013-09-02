class AddSuperToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :super, :boolean, :default => false
  end
end
