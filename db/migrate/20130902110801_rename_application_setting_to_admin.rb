class RenameApplicationSettingToAdmin < ActiveRecord::Migration
  def up
    rename_column :admins, :application_setting_id, :customer_id
  end

  def down
    rename_column :admins, :customer_id, :application_setting_id
  end
end
