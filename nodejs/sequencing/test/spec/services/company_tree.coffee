'use strict'

describe 'Service: companyTree', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  companyTree = {}
  beforeEach inject (_companyTree_) ->
    companyTree = _companyTree_

  it 'should do something', ->
    expect(!!companyTree).toBe true
