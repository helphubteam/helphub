import React from 'react'
import { observer } from 'mobx-react'
import articlesStore, { SORT_OPTIONS, GROUP_OPTIONS } from '../../stores/articles_store';

const ArticlesFilter = observer(() => {
  const { filters } = articlesStore
  return (
    <div className='row' id='articles-index'>
      <div className="input-group">
        <input
          type="text"
          name='query'
          value={filters.query}
          className="form-control"
          onChange={ ev => articlesStore.setFilter('query', ev.target.value) }
          placeholder="Query"
        />
      </div>
      <div className="input-group">
        <input
          type="text"
          name='limit'
          value={filters.limit}
          className="form-control"
          onChange={ ev => articlesStore.setFilter('limit', ev.target.value) }
          placeholder="Records limit"
        />
      </div>
      <div className="input-group">
        <select
          name='sort'
          value={filters.sort}
          className="form-control"
          onChange={ ev => articlesStore.setFilter('sort', ev.target.value) }
          placeholder="Records limit">
          {
            SORT_OPTIONS.map(option => <option value={option.value}>{option.name}</option>)
          }
        </select>
      </div>
      <div className="input-group">
        <select
          name='group'
          value={filters.group}
          className="form-control"
          onChange={ ev => articlesStore.setFilter('group', ev.target.value) }
          placeholder="Group results by">
          <option></option>
          {
            GROUP_OPTIONS.map(option => <option value={option}>{option}</option>)
          }
        </select>
      </div>
      <div className="input-group">
        <label>
          Stories search:
          <input
            name="story"
            type="checkbox"
            checked={filters.stories}
            onChange={ ev => articlesStore.setFilter('stories', ev.target.value)} />
        </label>
      </div>
      <div className="btn-group" role="group">
        <button className='btn btn-primary' onClick={ () => articlesStore.fetchItems() }>Apply Filters</button>
        <button className='btn btn-danger' onClick={ () => articlesStore.cleanFilters() }>Clean Filters</button>
      </div>
    </div>
  )
})

export default ArticlesFilter
