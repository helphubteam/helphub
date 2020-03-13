import consumer from "./consumer"
import { articlesStore } from '../stores/articles_store'

consumer.subscriptions.create(
  "NotificationsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(_data) {
    articlesStore.fetchItems()
  }
});
