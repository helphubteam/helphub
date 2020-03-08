import React from 'react'
import PropTypes from 'prop-types'
import ArticleItem from './article'

const ArticlesGroupItem = ({ target }) => {
  return (
    <div className='col-lg-12 mx-auto story-item articles-group-item'>
      <div>{target.field}: <b>{target.value}</b></div>
      <div>
        { 
          target.articles.map(article => {
            return (
              <ArticleItem target={article} />
            )
          })
        }
      </div>
    </div>
  )
}

ArticlesGroupItem.defaultProps = {}

ArticlesGroupItem.propTypes = {
  target: PropTypes.object
}

export default ArticlesGroupItem
