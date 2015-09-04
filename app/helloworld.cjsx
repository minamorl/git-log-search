React = require 'react'
$     = require 'jquery'
_     = require 'lodash'

SearchBox = React.createClass
  getInitialState: ->
    textvalue: ""
    results: []
  componentDidMount: ->
    $.getJSON "/api/data.json", {q: this.state.textvalue}, (data) =>
      this.setState
        results: data.results
  eventChange: (e) ->
    this.setState
      textvalue: e.target.value
    $.getJSON "/api/data.json", {q: this.state.textvalue}, (data) =>
      this.setState
        results: data.results
  render: ->
    <div>
      <input type="text" value={this.state.textvalue} onChange={this.eventChange} />
      <ListUI filterWord={this.state.textvalue} results={this.state.results} />
    </div>

ListUI = React.createClass
  
  render: ->
    <ul>
      {
        for r, index in this.props.results
          <ListElement key={index} data={r}/>
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
