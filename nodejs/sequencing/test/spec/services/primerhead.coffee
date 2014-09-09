'use strict'

describe 'Service: PrimerHead', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  PrimerHead = {}
  beforeEach inject (_PrimerHead_) ->
    PrimerHead = _PrimerHead_

  it 'should do something', ->
    expect(!!PrimerHead).toBe true
