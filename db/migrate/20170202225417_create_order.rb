class CreateOrder < ActiveRecord::Migration
  def change

    create_table :orders do |t|
      t.belongs_to  :community, null: false
      t.integer     :total_net_price_cents, null: false
      t.integer     :total_gross_price_cents, null: false
      t.string      :total_shipping_price_cents
      t.string      :total_currency, limit: 3
      t.string      :buyer_id, limit: 22, null: false
      t.string      :seller_id, limit: 22, null: false
      t.timestamps  null: false
    end

    create_table :order_items do |t|
      t.belongs_to  :order,               null: false
      t.belongs_to  :listing,             null: false
      t.string      :title,               null: false
      t.integer     :shipping_cost_cents, null: false
      t.string      :currency,            null: false, limit: 3
      t.integer     :net_price_cents,     null: false
      t.decimal     :vat_amount,          null: false, default: 0.0
      t.integer     :quantity,            null: false, default: 1

      t.timestamps  null: false
    end

    reversible do |dir|
      dir.up do
        add_foreign_key :orders, :people, column: :buyer_id, name: :order_buyer_id
        add_foreign_key :orders, :people, column: :seller_id, name: :order_seller_id
        change_column_null :transactions, :listing_id, true
        add_reference :transactions, :order, index: true, foreign_key: { name: :transactions_order_fk}, name: :transactions_order_fk
        add_reference :conversations, :order, index: true, foreign_key: { name: :conversations_order_fk}, name: :conversations_order_fk
      end
      dir.down do
        change_column_null :transactions, :listing_id, false
        remove_reference :transactions, :order
        remove_reference :conversations, :order
      end
    end
  end
end
