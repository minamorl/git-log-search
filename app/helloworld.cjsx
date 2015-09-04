React = require 'react'
$     = require 'jquery'
_     = require 'lodash'

SearchBox = React.createClass
  getInitialState: ->
    textvalue: ""
  eventChange: (e) ->
    this.setState
      textvalue: e.target.value
  render: ->
    <div>
      <input type="text" value={this.state.textvalue} onChange={this.eventChange} />
      <ListUI filterWord={this.state.textvalue} />
    </div>

ListUI = React.createClass
  
  getInitialState: ->
    results: []
  componentDidMount: ->
    $.getJSON "/data.json", (data) =>
      this.setState
        results: data
  render: ->
    <ul>
      {
        filtered_results= []
        for r, index in this.state.results
          r.id = index
          if r.summary.indexOf(this.props.filterWord) != -1 or this.props.filterWord==""
            filtered_results.push r

        for result in filtered_results
          <ListElement key={result.id} data={result} />
      }
    </ul>

ListElement = React.createClass
  render:->
    <li>
      <div>{this.props.data.summary}</div>
      <div className="detail">
        <div className="commit-author">{this.props.data.author}</div>
        <div className="project">{this.props.data.project}</div>
      </div>
    </li>

React.render(
  <SearchBox />,
  document.getElementById 'searchbox'
)
