# app/controllers/api/v1/base_controller.rb
module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authenticate_user!

      respond_to :json

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

      private

      def not_found
        render json: { error: "Resource not found" }, status: :not_found
      end

      def unprocessable_entity(exception)
        render json: { errors: exception.record.errors }, status: :unprocessable_content
      end
    end
  end
end
