'use strict'

describe 'Controller: PlasmidsCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  PlasmidsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PlasmidsCtrl = $controller 'PlasmidsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
