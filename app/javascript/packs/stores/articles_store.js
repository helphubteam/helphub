import { observable } from 'mobx';

class ArticlesStore {
  @observable items

  constructor() {
    this.items = [];
  }

  setItems(items) {
    console.log('set items')
    console.log(items)
    this.items = items
  }
}

export default new ArticlesStore();
