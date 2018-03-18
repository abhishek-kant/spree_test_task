class CreateSpreeImportProductsTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_import_products_tasks do |t|
      t.string :import_file, null: false
      t.timestamps
    end
  end
end
