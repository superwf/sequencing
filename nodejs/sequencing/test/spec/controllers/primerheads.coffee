'use strict'

describe 'Controller: PrimerheadsCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  PrimerheadsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PrimerheadsCtrl = $controller 'PrimerheadsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
