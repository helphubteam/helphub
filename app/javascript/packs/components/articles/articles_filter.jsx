import React, { useState, useEffect } from 'react'
import PropTypes from 'prop-types'

// const DEFAULT_FILTERS = {
//   limit: 10,
//   query: ''
// }

const ArticlesFilter = (props) => {
  // const { filterCallback } = props
  // const [filters, setFilters] = useState(DEFAULT_FILTERS)
  
  // const bindSetFilter = (name) =>
  //   (value) =>
  //     setFilters({ ...filters, [name]: value })

  // const bindFilterCallback = () =>
  //   () => filterCallback(filters)


  // useEffect(() => {
  //   filterCallback(filters)
  // }, filters)

  return (
    <div className='row' id='articles-index'>
      <div className="input-group">
        <input type="text" className="form-control" placeholder="Query" />
      </div>
      <div className="btn-group">
        <button className='btn btn-primary'>Apply Filters</button>
      </div>
    </div>
  )
}

ArticlesFilter.defaultProps = {
}

ArticlesFilter.propTypes = {
  filterCallback: PropTypes.func
}

export default ArticlesFilter
