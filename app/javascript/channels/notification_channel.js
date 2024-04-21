import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
        console.log('connected');
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
        console.log('disconnected');
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log('received', data.notification);

    if (data.notification === "Your account has been approved") {  
      // Display a notification to the user
      const notificationContainer = document.getElementById('notifications');
      const notificationElement = document.createElement('div');
      notificationElement.classList.add('notification');
      notificationElement.textContent = data.notification;
      notificationContainer.appendChild(notificationElement);
    }
  }
});
