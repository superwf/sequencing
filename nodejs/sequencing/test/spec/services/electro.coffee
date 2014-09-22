'use strict'

describe 'Service: electro', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  electro = {}
  beforeEach inject (_electro_) ->
    electro = _electro_

  it 'should do something', ->
    expect(!!electro).toBe true
