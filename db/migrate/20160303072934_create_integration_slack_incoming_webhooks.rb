class CreateIntegrationSlackIncomingWebhooks < ActiveRecord::Migration
  def change
    create_table :integration_slack_incoming_webhooks do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.string :text, null: false, default: ''
      t.string :channel
      t.string :username
      t.string :icon_emoji
      t.string :icon_url

      t.boolean :on_article_posted, null: false, default: false
      t.boolean :on_article_edited, null: false, default: false
      t.boolean :on_article_commented, null: false, default: false
      t.boolean :on_article_stocked, null: false, default: false

      t.timestamps
    end

    add_index :integration_slack_incoming_webhooks, :on_article_posted, name: 'slack_incoming_webhooks_on_article_posted'
    add_index :integration_slack_incoming_webhooks, :on_article_edited, name: 'slack_incoming_webhooks_on_article_edited'
    add_index :integration_slack_incoming_webhooks, :on_article_commented, name: 'slack_incoming_webhooks_on_article_commented'
    add_index :integration_slack_incoming_webhooks, :on_article_stocked, name: 'slack_incoming_webhooks_on_article_stocked'
  end
end
