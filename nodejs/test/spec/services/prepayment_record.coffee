'use strict'

describe 'Service: prepaymentRecord', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  prepaymentRecord = {}
  beforeEach inject (_prepaymentRecord_) ->
    prepaymentRecord = _prepaymentRecord_

  it 'should do something', ->
    expect(!!prepaymentRecord).toBe true
