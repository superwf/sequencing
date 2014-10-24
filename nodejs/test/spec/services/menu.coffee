'use strict'

describe 'Service: Menu', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  Menu = {}
  beforeEach inject (_Menu_) ->
    Menu = _Menu_

  it 'should do something', ->
    expect(!!Menu).toBe true
