class Integration::Slack::IncomingWebhook < ActiveRecord::Base
  attr_accessor :article, :comment

  validates :url, presence: true
  validates :text, presence: true

  def post
    slack = Slack::Incoming::Webhooks.new(url, payload)
    slack.post replaced_text
  end

  private

  def payload
    _payload = {}
    _payload[:channel] = channel unless channel.blank?
    _payload[:username] = username unless username.blank?
    _payload[:icon_emoji] = icon_emoji unless icon_emoji.blank?
    _payload[:attachments] = [{
      fallback: replaced_text,
      # pretext: replaced_text,
      author_name: article.try(:user).try(:name) || '',
      title: article.try(:title) || '',
      title_link: article_url      
    }]

    _payload
  end

  def article_url
    return if article.nil?

    Rails.application.routes.url_helpers
      .article_url(article, host: Rails.application.config.action_mailer.default_url_options[:host])
  end

  def replaced_text
    return if article.nil?

    text.gsub('#{article.title}', article.title.to_s)
      .gsub('#{article.url}', article_url)
      .gsub('#{article.user}', article.user.try(:name))
  end
end
