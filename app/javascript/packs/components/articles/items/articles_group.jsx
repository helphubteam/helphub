import React from 'react'
import PropTypes from 'prop-types'
import ArticleItem from './article'

const ArticlesGroupItem = ({ target }) => (
    <div className="col-lg-12 mx-auto story-item articles-group-item">
      <div className="articles-group-item__label">{target.field}: <b>{target.value}</b></div>
      <div className="articles-group-item__articles">
        { 
          target.articles.map(article => (
              <ArticleItem key={article.id} target={article} />
            ))
        }
      </div>
    </div>
  )

ArticlesGroupItem.defaultProps = {}

ArticlesGroupItem.propTypes = {
  target: PropTypes.object
}

export default ArticlesGroupItem
