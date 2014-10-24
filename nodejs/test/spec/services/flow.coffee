'use strict'

describe 'Service: flow', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  flow = {}
  beforeEach inject (_flow_) ->
    flow = _flow_

  it 'should do something', ->
    expect(!!flow).toBe true
