'use strict'

describe 'Service: Procedure', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  Procedure = {}
  $httpBackend = null
  api = '/api/v1'

  beforeEach inject (_Procedure_, _$httpBackend_) ->
    $httpBackend = _$httpBackend_
    $httpBackend.when('GET', '/scripts/cn.json').respond({})
    Procedure = _Procedure_

  it 'can query procedures', ->
    $httpBackend.when('GET', api + '/procedures').respond([{name: 'procedure1'}, {name: 'procedure2'}])
    $httpBackend.flush()
    Procedure.query (data)->
      expect(data.length).toEqual(2)
