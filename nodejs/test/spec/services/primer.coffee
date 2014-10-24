'use strict'

describe 'Service: primer', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  primer = {}
  beforeEach inject (_primer_) ->
    primer = _primer_

  it 'should do something', ->
    expect(!!primer).toBe true
