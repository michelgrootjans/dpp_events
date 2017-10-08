class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.string :reference
      t.string :tags
      t.string :status

      t.timestamps
    end
  end
end
