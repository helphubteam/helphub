import { observable } from 'mobx'
import axios from 'axios'
import Api from 'packs/lib/api'

const DEFAULT_FILTERS = {
  limit: 10,
  sort: 'created_at DESC',
  query: '',
  group: '',
  stories: false
}

export const SORT_OPTIONS = [
  {name: 'Newer first', value: 'created_at DESC'},
  {name: 'Older first', value: 'created_at ASC'},
  {name: 'ABC', value: 'name ASC'},
  {name: 'ZYX', value: 'name DESC'}]

export const GROUP_OPTIONS = [
  'name', 'content', 'kind', 'created_at', 'updated_at'
]
class ArticlesStore {
  @observable items
  @observable filters

  constructor() {
    this.items = [];
    this.filters = { ...DEFAULT_FILTERS }
  }

  setFilter(name, value) {
    this.filters = {...this.filters, [name]: value}
  }

  setFilters(filters) {
    this.filters = { ...filters }
  }

  cleanFilters() {
    this.setFilters(DEFAULT_FILTERS)
    this.fetchItems()
  }

  fetchItems() {
    axios.get(Api.articles, { 
      params: this.buildParams(this.filters),
      headers: { 'Content-Type': 'application/json' },
      responseType: 'json'
    }).
    then(response => this.items = response.data)
  }

  buildParams(filters) {
    const params = { ...filters }
    if (params.stories && params.group) {
      delete params.group
    }
    return params
  }
}

export default new ArticlesStore();
