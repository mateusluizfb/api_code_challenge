class AddIndexToHostnames < ActiveRecord::Migration[6.1]
  def change
    add_index :hostnames, :name
  end
end
