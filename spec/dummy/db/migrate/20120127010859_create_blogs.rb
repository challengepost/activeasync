class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|

      t.timestamps
    end
  end
end
