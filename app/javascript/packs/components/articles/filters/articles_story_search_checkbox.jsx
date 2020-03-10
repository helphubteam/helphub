import React from 'react'
import { observer } from 'mobx-react'
import articlesStore from '../../../stores/articles_store';

const ArticlesStorySearchCheckbox = observer(() => (
  <label>
    Stories search:
    <input
      name="story"
      type="checkbox"
      checked={articlesStore.filters.stories}
      onChange={ ev => articlesStore.setFilter('stories', ev.target.checked) }
    />
  </label>
))

export default ArticlesStorySearchCheckbox
