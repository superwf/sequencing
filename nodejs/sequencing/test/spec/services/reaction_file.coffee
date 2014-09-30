'use strict'

describe 'Service: reactionFile', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  reactionFile = {}
  beforeEach inject (_reactionFile_) ->
    reactionFile = _reactionFile_

  it 'should do something', ->
    expect(!!reactionFile).toBe true
