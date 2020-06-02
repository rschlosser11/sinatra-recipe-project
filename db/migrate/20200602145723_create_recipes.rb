class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :directions
      t.string :cook_time
      t.string :prep_time
      t.string :meal_type
      t.string :dish_type
      t.string :cuisine_type
      t.integer :servings
      t.integer :user_id
      t.integer :article_id
    end
  end
end
