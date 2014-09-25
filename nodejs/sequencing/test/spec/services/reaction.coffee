'use strict'

describe 'Service: reaction', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  reaction = {}
  beforeEach inject (_reaction_) ->
    reaction = _reaction_

  it 'should do something', ->
    expect(!!reaction).toBe true
