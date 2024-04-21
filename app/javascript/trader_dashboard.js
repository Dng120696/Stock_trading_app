import consumer from "channels/consumer";

document.addEventListener('turbo:load', () => {
  // Subscribe to the NotificationChannel
  consumer.subscriptions.create("NotificationChannel", {
    connected() {
      console.log("Connected to NotificationChannel");
    },

    disconnected() {
      console.log("Disconnected from NotificationChannel");
    },

    received(data) {
      console.log('Received data from NotificationChannel:', data.notification);
      // Handle incoming message, update UI, etc.
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
});
