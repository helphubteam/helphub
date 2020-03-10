import React from 'react'
import { observer } from 'mobx-react'
import articlesStore from '../../../stores/articles_store';

const ArticlesQueryInput = observer(() => (
  <input
    type="text"
    name='query'
    value={articlesStore.filters.query}
    className="form-control"
    onChange={ ev => articlesStore.setFilter('query', ev.target.value) }
    placeholder="Query"
  />
))

export default ArticlesQueryInput
