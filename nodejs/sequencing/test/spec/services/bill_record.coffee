'use strict'

describe 'Service: billRecord', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  billRecord = {}
  beforeEach inject (_billRecord_) ->
    billRecord = _billRecord_

  it 'should do something', ->
    expect(!!billRecord).toBe true
