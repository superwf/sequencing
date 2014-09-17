'use strict'

describe 'Controller: BoardCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  BoardCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    BoardCtrl = $controller 'BoardCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
