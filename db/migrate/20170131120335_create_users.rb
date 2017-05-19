class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :nome
      t.string :login
      t.string :password_digest
      t.string :steamid
      t.string :email
      t.boolean :ativo, default: true
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
