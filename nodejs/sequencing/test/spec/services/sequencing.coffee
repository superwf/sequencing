'use strict'

describe 'Service: Sequencing', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  Sequencing = {}
  beforeEach inject (_Sequencing_) ->
    Sequencing = _Sequencing_

  it 'should do something', ->
    expect(!!Sequencing).toBe true
