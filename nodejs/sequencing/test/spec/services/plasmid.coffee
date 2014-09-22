'use strict'

describe 'Service: plasmid', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  plasmid = {}
  beforeEach inject (_plasmid_) ->
    plasmid = _plasmid_

  it 'should do something', ->
    expect(!!plasmid).toBe true
