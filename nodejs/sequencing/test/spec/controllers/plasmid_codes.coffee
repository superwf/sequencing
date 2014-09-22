'use strict'

describe 'Controller: PlasmidCodesCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  PlasmidCodesCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PlasmidCodesCtrl = $controller 'PlasmidCodesCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
