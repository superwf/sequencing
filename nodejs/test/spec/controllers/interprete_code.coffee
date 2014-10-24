'use strict'

describe 'Controller: InterpreteCodeCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  InterpreteCodeCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    InterpreteCodeCtrl = $controller 'InterpreteCodeCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
