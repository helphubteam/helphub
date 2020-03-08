import React from 'react'
import PropTypes from 'prop-types'
import cn from 'classnames'
  import ArticleItem from './article'

const renderArticlesInfo = (data) =>
  Object.keys(data).map((key, index) => {
    const value = data[key]
    return (
      <div id={index}>{key}&nbsp;<span className="badge">{value}</span></div>
    )
  });

const StoryItem = ({ target }) => {
  return (
    <div className='col-lg-12 mx-auto story-item'>
      <h4>{target.name}</h4>
      <b>{`Story of ${target.articles_count} articles`}</b>
      <div>{renderArticlesInfo(target.articles_types_count)}</div>
      <ArticleItem target={target.last_article} />
    </div>
  )
}

export default StoryItem
