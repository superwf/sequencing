'use strict'

describe 'Service: sampleHead', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  sampleHead = {}
  beforeEach inject (_sampleHead_) ->
    sampleHead = _sampleHead_

  it 'should do something', ->
    expect(!!sampleHead).toBe true
