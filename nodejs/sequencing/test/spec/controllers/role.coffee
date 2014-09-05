'use strict'

describe 'Controller: RoleCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  RoleCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    RoleCtrl = $controller 'RoleCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
