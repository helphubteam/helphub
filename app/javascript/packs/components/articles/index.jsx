import React, { useState, useEffect } from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

import Api from 'packs/lib/api'
import { buildItemComponent } from 'packs/lib/helpers'

const fetchArticles = (updateItems) => {
  fetch(Api.articles, { 
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

const ArticlesIndex = () => {
  const [items, setitems] = useState([])
  useEffect(() => {
    fetchArticles(setitems)
  }, [] )
  return (
    <div id='articles-index'>
      {renderItems(items)}
    </div>
  )
}

ArticlesIndex.defaultProps = {
  name: 'David'
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
