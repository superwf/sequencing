'use strict'

describe 'Controller: VectorCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  VectorCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    VectorCtrl = $controller 'VectorCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
