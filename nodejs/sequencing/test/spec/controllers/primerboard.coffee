'use strict'

describe 'Controller: PrimerboardCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  PrimerboardCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PrimerboardCtrl = $controller 'PrimerboardCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
