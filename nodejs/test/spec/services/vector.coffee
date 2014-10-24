'use strict'

describe 'Service: vector', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  vector = {}
  beforeEach inject (_vector_) ->
    vector = _vector_

  it 'should do something', ->
    expect(!!vector).toBe true
