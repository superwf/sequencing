'use strict'

describe 'Service: interpreteCode', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  interpreteCode = {}
  beforeEach inject (_interpreteCode_) ->
    interpreteCode = _interpreteCode_

  it 'should do something', ->
    expect(!!interpreteCode).toBe true
