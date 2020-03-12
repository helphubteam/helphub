import consumer from "./consumer"
import articlesStore from '../packs/stores/articles_store'

consumer.subscriptions.create({
  channel: "WebNotifications",
  received (_data) {
    articlesStore.fetchItems()
  }
});
