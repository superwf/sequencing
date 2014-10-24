'use strict'

describe 'Controller: ReactionFilesCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  ReactionFilesCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ReactionFilesCtrl = $controller 'ReactionFilesCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
