import React from 'react'
import PropTypes from 'prop-types'
import cn from 'classnames'
import { truncate } from 'packs/lib/helpers'

const MAX_CONTENT_SIZE = 200

const KIND_LABELS = {
  post: 'label-success',
  tweet: 'label-info',
  facebook: 'label-primary',
  blog: 'label-danger'
}

const ArticleItem = ({ target }) => (
    <div className="col-lg-12 mx-auto article-item">
      <span className={cn("label", KIND_LABELS[target.kind])}>{target.kind}</span>
      <span className={cn('label', 'label-default', 'timestamp')}>{target.created_at}</span>
      <h4>{target.name}</h4>
      <p>{truncate(target.content, MAX_CONTENT_SIZE)}</p>
    </div>
  )

ArticleItem.defaultProps = {}

ArticleItem.propTypes = {
  target: PropTypes.object
}

export default ArticleItem
