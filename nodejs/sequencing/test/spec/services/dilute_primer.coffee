'use strict'

describe 'Service: dilutePrimer', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  dilutePrimer = {}
  beforeEach inject (_dilutePrimer_) ->
    dilutePrimer = _dilutePrimer_

  it 'should do something', ->
    expect(!!dilutePrimer).toBe true
