import React from 'react'
import PropTypes from 'prop-types'

const ArticleItem = ({ target }) => {
  return (
    <div id='article-item'>
      <div>{target.kind}</div>
      <div>{target.name}</div>
      <p>{target.content}</p>
    </div>
  )
}

ArticleItem.defaultProps = {}

ArticleItem.propTypes = {
  target: PropTypes.object
}

export default ArticleItem
