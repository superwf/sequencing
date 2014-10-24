'use strict'

describe 'Controller: BoardsCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  BoardsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    BoardsCtrl = $controller 'BoardsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
