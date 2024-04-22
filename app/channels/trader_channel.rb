class TraderChannel < ApplicationCable::Channel
  def subscribed
    user_id = params[:user_id]
    if user_id
      stream_from "trader_channel_#{user_id}"
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
