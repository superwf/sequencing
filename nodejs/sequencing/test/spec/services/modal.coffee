'use strict'

describe 'Service: modal', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  modal = {}
  beforeEach inject (_modal_) ->
    modal = _modal_

  it 'should do something', ->
    expect(!!modal).toBe true
