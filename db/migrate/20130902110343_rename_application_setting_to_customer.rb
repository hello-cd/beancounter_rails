class RenameApplicationSettingToCustomer < ActiveRecord::Migration
  def up
    rename_table :application_settings, :customers
  end

  def down
    rename_table :customers, :application_settings
  end
end
