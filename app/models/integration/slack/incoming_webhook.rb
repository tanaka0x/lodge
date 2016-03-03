class Integration::Slack::IncomingWebhook < ActiveRecord::Base
  validates :url, presence: true
  validates :text, presence: true

  def post(payload = {})
    payload[:channel] = channel unless channel.blank?
    payload[:username] = username unless username.blank?
    payload[:icon_emoji] = icon_emoji unless icon_emoji.blank?

    slack = Slack::Incoming::Webhooks.new(url, payload)

    slack.post text
  end
end
