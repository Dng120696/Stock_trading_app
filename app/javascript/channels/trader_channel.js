import consumer from "channels/consumer"
const user_id = "<%= current_user.id %>";

consumer.subscriptions.create("TraderChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('connected to server');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log('disconnected from server');
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log('received data')
    alert(data.message); 
  }
});
