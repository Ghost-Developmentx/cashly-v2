# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def create
    @message = @conversation.add_message(message_params[:content], "user")

    # Process message with AI service (will implement later)
    # For now, just creates a fake response
    @response = @conversation.add_message("This is a placeholder response for: #{@message.content}", "assistant")

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @conversation }
    end
  end

  private

  def set_conversation
    @conversation = current_user.fin_conversations.find(params[:conversation_id])
  end

  def message_params
    params.require(:fin_message).permit(:content)
  end
end
