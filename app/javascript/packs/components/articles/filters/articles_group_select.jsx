import React from 'react'
import { observer } from 'mobx-react'
import articlesStore, { GROUP_OPTIONS } from '../../../stores/articles_store';

const ArticlesGroupSelect = observer(() => (
  <select
    name="group"
    value={articlesStore.filters.group}
    className="form-control"
    onChange={ ev => articlesStore.setFilter('group', ev.target.value) }
    placeholder="Group results by">
    <option></option>
    {
      GROUP_OPTIONS.map(option => <option key={option} value={option}>{option}</option>)
    }
  </select>
))

export default ArticlesGroupSelect
