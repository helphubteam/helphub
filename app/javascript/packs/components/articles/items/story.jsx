import React from 'react'
import PropTypes from 'prop-types'

const StoryItem = ({ target }) => {
  return (
    <div id='story-item'>
      <div>{target.name}</div>
    </div>
  )
}

StoryItem.defaultProps = {}

StoryItem.propTypes = {
  target: PropTypes.object
}

export default StoryItem
