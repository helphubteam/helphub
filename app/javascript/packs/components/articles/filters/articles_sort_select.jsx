import React from 'react'
import { observer } from 'mobx-react'
import articlesStore, { SORT_OPTIONS } from '../../../stores/articles_store';

const ArticlesSortSelect = observer(() => (
  <select
    name="sort"
    value={articlesStore.filters.sort}
    className="form-control"
    onChange={ ev => articlesStore.setFilter('sort', ev.target.value) }
    placeholder="Records limit">
    {
      SORT_OPTIONS.map(option => <option key={option.value} value={option.value}>{option.name}</option>)
    }
  </select>
))

export default ArticlesSortSelect
