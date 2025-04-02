# app/controllers/conversations_controller.rb
class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [ :show ]

  def index
    @conversations = current_user.fin_conversations.recent
  end

  def show
    @messages = @conversation.fin_messages.chronological
  end

  def new
    @conversation = current_user.fin_conversations.build
  end

  def create
    @conversation = current_user.fin_conversations.build(conversation_params)

    if @conversation.save
      # Create a welcome message from Fin
      @conversation.add_message("Hi! I'm Fin, your financial assistant. How can I help you today?", "assistant")

      redirect_to @conversation, notice: "Conversation started"
    else
      render :new
    end
  end

  private

  def set_conversation
    @conversation = current_user.fin_conversations.find(params[:id])
  end

  def conversation_params
    params.require(:fin_conversation).permit(:title).merge(
      status: "active",
      context: {},
      metadata: {}
    )
  end
end
