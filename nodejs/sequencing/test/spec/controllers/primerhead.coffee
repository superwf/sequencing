'use strict'

describe 'Controller: PrimerheadCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  PrimerheadCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PrimerheadCtrl = $controller 'PrimerheadCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
