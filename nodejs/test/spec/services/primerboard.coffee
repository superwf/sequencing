'use strict'

describe 'Service: primerBoard', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  primerBoard = {}
  beforeEach inject (_primerBoard_) ->
    primerBoard = _primerBoard_

  it 'should do something', ->
    expect(!!primerBoard).toBe true
