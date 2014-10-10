'use strict'

describe 'Service: bill', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  bill = {}
  beforeEach inject (_bill_) ->
    bill = _bill_

  it 'should do something', ->
    expect(!!bill).toBe true
