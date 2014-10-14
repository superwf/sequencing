'use strict'

describe 'Controller: ReworkOrderCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  ReworkOrderCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ReworkOrderCtrl = $controller 'ReworkOrderCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
