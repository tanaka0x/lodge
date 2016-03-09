class IntegrationsController < ApplicationController
  before_action :set_integrations, only: [:index]

  def index

  end

  private

  def set_integrations
    @integrations = [{
      name: 'Slack: Incoming webhooks',
      url: polymorphic_path(Integration::Slack::IncomingWebhook),
      image_path: 'Slack-icon.png' 
   }]
  end
end
