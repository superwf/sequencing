'use strict'

describe 'Controller: PrimerboardsCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  PrimerboardsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PrimerboardsCtrl = $controller 'PrimerboardsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
