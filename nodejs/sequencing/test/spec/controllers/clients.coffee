'use strict'

describe 'Controller: ClientsCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  ClientsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ClientsCtrl = $controller 'ClientsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
