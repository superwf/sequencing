'use strict'

describe 'Controller: RolesCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  RolesCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    RolesCtrl = $controller 'RolesCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
