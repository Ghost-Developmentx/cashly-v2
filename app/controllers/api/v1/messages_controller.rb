# app/controllers/api/v1/messages_controller.rb
module Api
  module V1
    class MessagesController < BaseController
      before_action :set_conversation
      before_action :set_message, only: [ :show, :update, :destroy ]

      def index
        @messages = @conversation.fin_messages.chronological
        render json: @messages
      end

      def show
        render json: @message
      end

      def create
        @message = @conversation.fin_messages.build(message_params)

        if @message.save
          # Process message with AI service (will implement later)
          # For now, just creates a fake response
          @response = @conversation.fin_messages.create(
            content: "This is a placeholder response for: #{@message.content}",
            role: "assistant",
            metadata: {}
          )

          render json: [ @message, @response ], status: :created
        else
          render json: { errors: @message.errors }, status: :unprocessable_content
        end
      end

      private

      def set_conversation
        @conversation = current_user.fin_conversations.find(params[:conversation_id])
      end

      def set_message
        @message = @conversation.fin_messages.find(params[:id])
      end

      def message_params
        params.require(:message).permit(:content, metadata: {}).merge(role: "user")
      end
    end
  end
end
