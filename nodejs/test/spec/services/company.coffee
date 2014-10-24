'use strict'

describe 'Service: Company', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  Company = {}
  beforeEach inject (_Company_) ->
    Company = _Company_

  it 'should do something', ->
    expect(!!Company).toBe true
