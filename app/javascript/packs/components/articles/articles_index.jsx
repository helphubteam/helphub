import React, { useState, useEffect } from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import { observer } from 'mobx-react';

import articlesStore from '../../stores/articles_store';
//import filtersStore from '../../stores/filters_store';

import Api from 'packs/lib/api'
import { buildItemComponent } from 'packs/lib/helpers'
import ArticlesFilter from './articles_filter'

const fetchArticles = (data, updateItems) => {
  fetch(Api.articles, { 
    ...data,
    headers: {
      'Content-Type': 'application/json',
    }
  }).
  then(response => response.json()).
  then(updateItems)
}

const renderItems = (items) => (
  items.map(buildItemComponent)
)

const ArticlesIndex = observer(() => {
  useEffect(() => {
    fetchArticles({}, articlesStore.setitems)
  }, [] )

  const fetchArticlesOnFiltering = (filters) =>
    fetchArticles(filters, setitems)

  return (
    <div className='row' id='articles-index'>
      <div className='col-lg-6'>
        {renderItems(articlesStore.items)}
      </div>
      <div className='col-lg-6'>
        <ArticlesFilter filterCallback={fetchArticlesOnFiltering}/>
      </div>
    </div>
  )
})

ArticlesIndex.defaultProps = {
}

ArticlesIndex.propTypes = {
  name: PropTypes.string
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <ArticlesIndex name="React" />,
    document.getElementById('articles-container'),
  )
})
