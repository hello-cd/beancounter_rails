class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.integer :application_setting_id
      t.string :username

      t.timestamps
    end
  end
end
