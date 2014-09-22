'use strict'

describe 'Service: shakeBac', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  shakeBac = {}
  beforeEach inject (_shakeBac_) ->
    shakeBac = _shakeBac_

  it 'should do something', ->
    expect(!!shakeBac).toBe true
