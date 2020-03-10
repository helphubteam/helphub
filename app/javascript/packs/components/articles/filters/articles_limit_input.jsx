import React from 'react'
import { observer } from 'mobx-react'
import articlesStore from '../../../stores/articles_store';

const ArticlesLimitInput = observer(() => (
  <input
    type="text"
    name='limit'
    value={articlesStore.filters.limit}
    className="form-control"
    onChange={ ev => articlesStore.setFilter('limit', ev.target.value) }
    placeholder="Records limit"
  />
))

export default ArticlesLimitInput
