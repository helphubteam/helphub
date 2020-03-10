import React from 'react'
import { observer } from 'mobx-react'
import articlesStore from '../../stores/articles_store';
import ArticlesQueryInput from './filters/articles_query_input'
import ArticlesLimitInput from './filters/articles_limit_input'
import ArticlesSortSelect from './filters/articles_sort_select'
import ArticlesGroupSelect from './filters/articles_group_select'
import ArticlesStorySearchCheckbox from './filters/articles_story_search_checkbox'

const ArticlesFilter = observer(() => (
  <div className='row' id='articles-index'>
    <div className="input-group">
      <ArticlesQueryInput />
    </div>
    <div className="input-group">
      <ArticlesLimitInput />
    </div>
    <div className="input-group">
      <ArticlesSortSelect />
    </div>
    <div className="input-group">
      <ArticlesStorySearchCheckbox />
    </div>
    {
      !articlesStore.filters.stories && <div className="input-group">
        <ArticlesGroupSelect />
      </div>
    }
    <div className="btn-group" role="group">
      <button className='btn btn-primary' onClick={ () => articlesStore.fetchItems() }>Apply Filters</button>
      <button className='btn btn-danger' onClick={ () => articlesStore.cleanFilters() }>Clean Filters</button>
    </div>
  </div>
))

export default ArticlesFilter
