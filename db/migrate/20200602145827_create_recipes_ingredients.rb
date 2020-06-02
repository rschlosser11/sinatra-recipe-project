class CreateRecipesIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :recicpes_ingredients do |t|
      t.integer :recipe_id
      t.integer :ingredient_id
      t.string :amount
      t.string :unit_of_measure
    end
  end
end
