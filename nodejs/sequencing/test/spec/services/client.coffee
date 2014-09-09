'use strict'

describe 'Service: client', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  client = {}
  beforeEach inject (_client_) ->
    client = _client_

  it 'should do something', ->
    expect(!!client).toBe true
