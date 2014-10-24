'use strict'

describe 'Service: plasmidCode', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  plasmidCode = {}
  beforeEach inject (_plasmidCode_) ->
    plasmidCode = _plasmidCode_

  it 'should do something', ->
    expect(!!plasmidCode).toBe true
