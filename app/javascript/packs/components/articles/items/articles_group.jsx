import React from 'react'
import PropTypes from 'prop-types'

const ArticlesGroupItem = ({ target }) => {
  return (
    <div id='articles-group-item'>
      <div>{target.field}:</div>
      <div>{target.value}</div>
    </div>
  )
}

ArticlesGroupItem.defaultProps = {}

ArticlesGroupItem.propTypes = {
  target: PropTypes.object
}

export default ArticlesGroupItem
