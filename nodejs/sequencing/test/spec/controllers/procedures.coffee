'use strict'

describe 'Controller: ProcedureCtrl', ->

  beforeEach(module('sequencingApp'))

  ProcedureCtrl = null
  scope = null
  $httpBackend = null
  api = '/api/v1'

  beforeEach inject ($controller, _$httpBackend_, $rootScope)->
    $httpBackend = _$httpBackend_
    scope = $rootScope.$new()
    MainCtrl = $controller('ProceduresCtrl', {
      $scope: scope
    })
    $httpBackend.when('GET', api + '/procedures').respond([{name: 'procedure1'}, {name: 'p2'}])
    $httpBackend.when('GET', '/scripts/cn.json').respond({})

  it 'should has records', ->
    $httpBackend.flush()
    expect(scope.records.length).toBe(2)
    expect(scope.records[0].name).toBe('procedure1')
   
  it 'test delete', ->
    $httpBackend.flush()
    $httpBackend.when('DELETE', api + '/procedures/1').respond({})
    expect(scope.records.length).toBe(2)
    scope.delete(1, 0)
    $httpBackend.flush()
    expect(scope.records.length).toBe(1)
