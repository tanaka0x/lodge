class Integration::Slack::IncomingWebhooksController < ApplicationController
  before_action :set_incoming_webhook, only: [:show, :edit, :update, :destroy ]

  IncomingWebhook = Integration::Slack::IncomingWebhook
  def index
    @hooks = IncomingWebhook.order(created_at: :desc)
  end

  def show

  end

  def new
    @hook = IncomingWebhook.new
  end

  def create
    @hook = IncomingWebhook.new(incoming_webhook_params)

    respond_to do |format|
      if @hook.save
        format.html { redirect_to @hook, notice: 'Hook was successfully created.' }
        format.json { render :show, status: :created, location: @hook }
      else
        format.html { render :new }
        format.json { render json: @hook.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit

  end

  def update

  end

  def destroy
    @hook.destroy

    respond_to do |format|
      format.html { redirect_to integration_slack_incoming_webhooks_path, notice: 'Incoming webhook was destroyed' }
      format.json { head :no_content }
    end
  end

  private

  def incoming_webhook_params
    params.require(:integration_slack_incoming_webhook)
      .permit(:url, :text, :channel, :username, :icon_emoji, :icon_url)
  end

  def set_incoming_webhook
    @hook = IncomingWebhook.find_by_id(params[:id])
  end
end
