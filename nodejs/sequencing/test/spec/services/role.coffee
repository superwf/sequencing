'use strict'

describe 'Service: role', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  role = {}
  beforeEach inject (_role_) ->
    role = _role_

  it 'should do something', ->
    expect(!!role).toBe true
