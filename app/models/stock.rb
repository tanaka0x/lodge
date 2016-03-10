class Stock < ActiveRecord::Base
  belongs_to :user
  belongs_to :article
  after_create :create_notification

  validates_uniqueness_of :user, :scope => :article

  after_commit :execute_integrations_hook

  def create_notification
    article = self.article
    return if self.user_id == article.user_id
    notification = StockNotification.create!(
      user_id: self.user_id,
      state: :create,
      article_id: article.id,
    )
    notification.create_targets_for_owner_by_article(article)
  end

  private

  def execute_integrations_hook
    if transaction_include_any_action? [:create]
      Integration::Slack::IncomingWebhook.on_article_stocked.each do |hook|
        hook.post self
      end
    end
  end
end
