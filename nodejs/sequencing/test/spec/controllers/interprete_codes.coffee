'use strict'

describe 'Controller: InterpreteCodesCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  InterpreteCodesCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    InterpreteCodesCtrl = $controller 'InterpreteCodesCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
