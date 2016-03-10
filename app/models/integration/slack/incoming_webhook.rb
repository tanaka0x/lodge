class Integration::Slack::IncomingWebhook < ActiveRecord::Base
  attr_accessor :article, :comment, :stock

  validates :url, presence: true
  validates :text, presence: true

  scope :on_article_posted, -> { where(on_article_posted: true) }
  scope :on_article_edited, -> { where(on_article_edited: true) }
  scope :on_article_commented, -> { where(on_article_commented: true) }
  scope :on_article_stocked, -> { where(on_article_stocked: true) }

  def post(obj)
    options = setup_by obj
    slack = Slack::Incoming::Webhooks.new(url, options)
    slack.post replaced_text
  end

  private



  def setup_by(obj)
    case obj
    when Article
      @article = obj
    when Comment
      @comment = obj
      @article = comment.article
      return payload({
        attachments: {
          fallback: "#{@comment.user.name} commented to <#{article_url}|#{@article.title}>",
          author_name: @comment.user.name
        }
      })
    when Stock
      @stock = obj
      @article = stock.article
    else
      raise "#{obj.class} is not supported by #{self.class}"
    end

    payload
  end

  def payload(overwrite_attributes = {})
    _payload = {}
    _payload[:channel] = channel unless channel.blank?
    _payload[:username] = username || 'LodgeBot'
    _payload[:icon_emoji] = icon_emoji unless icon_emoji.blank?
    _payload[:icon_url] = icon_url unless icon_url.blank?
    _payload[:attachments] = [{
      fallback: replaced_text,
      # pretext: replaced_text,
      author_name: @article.try(:user).try(:name) || '',
      title: @article.try(:title) || '',
      title_link: article_url      
    }.merge(overwrite_attributes)]

    _payload
  end

  def article_url
    return if @article.nil?

    Rails.application.routes.url_helpers
      .article_url(@article, host: Rails.application.config.action_mailer.default_url_options[:host])
  end

  def replaced_text
    return if @article.nil?

    result = text
    @@text_placeholders.each do |p|
      result.gsub!(p[:pattern], instance_exec(&p[:placement]))
    end
    
    result
  end

  @@text_placeholders = []
  def self.append_replacement(pattern, placement)
    @@text_placeholders = [] unless @@text_placeholders.is_a? Array
    @@text_placeholders.push({ pattern: pattern, placement: placement })
  end

  append_replacement '#{article.title}', -> { @article.try(:title) }
  append_replacement '#{article.url}', -> { article_url }
  append_replacement '#{article.user}', -> { @article.try(:user).name }
  append_replacement '#{comment.user}', -> { @comment.try(:user).name }
end
