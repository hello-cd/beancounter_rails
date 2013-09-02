class RemoveSuperFromAdmin < ActiveRecord::Migration
  def up
    remove_column :admins, :super
  end

  def down
    add_column :admins, :super, :boolean
  end
end
