'use strict'

describe 'Controller: PrecheckCodeCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  PrecheckCodeCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PrecheckCodeCtrl = $controller 'PrecheckCodeCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
