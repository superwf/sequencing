'use strict'

describe 'Service: boardRecord', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  boardRecord = {}
  beforeEach inject (_boardRecord_) ->
    boardRecord = _boardRecord_

  it 'should do something', ->
    expect(!!boardRecord).toBe true
