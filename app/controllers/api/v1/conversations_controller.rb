# app/controllers/api/v1/conversations_controller.rb
module Api
  module V1
    class ConversationsController < BaseController
      before_action :set_conversation, only: [ :show, :update, :destroy ]

      def index
        @conversations = current_user.fin_conversations.recent
        render json: @conversations
      end

      def show
        render json: @conversation, include: [ "fin_messages" ]
      end

      def create
        @conversation = current_user.fin_conversations.build(conversation_params)

        if @conversation.save
          render json: @conversation, status: :created
        else
          render json: { errors: @conversation.errors }, status: :unprocessable_content
        end
      end
      def update
        if @conversation.update(conversation_params)
          render json: @conversation
        else
          render json: { errors: @conversation.errors }, status: :unprocessable_content
        end
      end

      def destroy
        @conversation.destroy
        head :no_content
      end

      private

      def set_conversation
        @conversation = current_user.fin_conversations.find(params[:id])
      end

      def conversation_params
        params.require(:conversation).permit(:title, :status, context: {}, metadata: {})
      end
    end
  end
end
