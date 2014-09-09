'use strict'

describe 'Controller: ClientCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  ClientCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ClientCtrl = $controller 'ClientCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
