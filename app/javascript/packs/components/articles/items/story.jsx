import React from 'react'
import PropTypes from 'prop-types'
import ArticleItem from './article'

const renderArticlesInfo = data => Object.keys(data).map((key, index) => {
    const value = data[key]
    
return (
      <div key={index}>{key}&nbsp;<span className="badge">{value}</span></div>
    )
  });

const StoryItem = ({ target }) => (
    <div className="col-lg-12 mx-auto story-item">
      <h4>{target.name}</h4>
      <b>{`Story of ${target.articles_count} articles`}</b>
      <div>{renderArticlesInfo(target.articles_types_count)}</div>
      <ArticleItem target={target.last_article} />
    </div>
  )

StoryItem.defaultProps = {}

StoryItem.propTypes = {
  target: PropTypes.object
}

export default StoryItem
