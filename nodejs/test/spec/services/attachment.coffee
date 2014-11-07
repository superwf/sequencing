'use strict'

describe 'Service: attachment', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  attachment = {}
  beforeEach inject (_attachment_) ->
    attachment = _attachment_

  it 'should do something', ->
    expect(!!attachment).toBe true
