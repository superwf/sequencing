'use strict'

describe 'Service: precheckCode', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  precheckCode = {}
  beforeEach inject (_precheckCode_) ->
    precheckCode = _precheckCode_

  it 'should do something', ->
    expect(!!precheckCode).toBe true
