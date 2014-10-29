'use strict'

describe 'Service: prepayment', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  prepayment = {}
  beforeEach inject (_prepayment_) ->
    prepayment = _prepayment_

  it 'should do something', ->
    expect(!!prepayment).toBe true
