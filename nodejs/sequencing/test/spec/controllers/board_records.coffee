'use strict'

describe 'Controller: BoardRecordsCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  BoardRecordsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    BoardRecordsCtrl = $controller 'BoardRecordsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
