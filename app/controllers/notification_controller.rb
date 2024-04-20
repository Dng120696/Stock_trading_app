class NotificationController < ApplicationController
  def index
    @notifications = current_user.notifications.unread
    render json: @notifications
  end
end
