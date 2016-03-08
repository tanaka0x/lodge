class IntegrationsController < ApplicationController
  before_action :set_integrations, only: [:index]

  def index

  end

  private

  def set_integrations
    @integrations = [:slack_incoming_webhook]
  end
end
