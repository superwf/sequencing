'use strict'

describe 'Service: precheck', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  precheck = {}
  beforeEach inject (_precheck_) ->
    precheck = _precheck_

  it 'should do something', ->
    expect(!!precheck).toBe true
