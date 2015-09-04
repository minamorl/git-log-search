React = require 'react'

SearchBox = React.createClass
  getInitialState: ->
    textvalue: "aaa"
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
    results: [
      "text1",
      "text2",
      "text3",
      "text4",
    ]
  render: ->
    <ul>
      {
        filtered_results= []
        for r in this.state.results
          if r.indexOf(this.props.filterWord) != -1 or this.props.filterWord==""
            filtered_results.push r

        for result in filtered_results
          <ListElement key={result} word={result} />
      }
    </ul>

ListElement = React.createClass
  render:->
    <li>{this.props.word}</li>

React.render(
  <SearchBox />,
  document.getElementById 'searchbox'
)
