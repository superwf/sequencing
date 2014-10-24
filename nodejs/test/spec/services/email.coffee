'use strict'

describe 'Service: email', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  email = {}
  beforeEach inject (_email_) ->
    email = _email_

  it 'should do something', ->
    expect(!!email).toBe true
