'use strict'

describe 'Controller: BoardholeCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  BoardholeCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    BoardholeCtrl = $controller 'BoardholeCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
