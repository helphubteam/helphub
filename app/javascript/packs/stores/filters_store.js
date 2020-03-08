import { observable } from 'mobx';

class FiltersStore {
  @observable filters

  constructor() {
    this.filters = {};
  }

  setFilters(filters) {
    this.filters = filters
  }
}

export default new FiltersStore();
