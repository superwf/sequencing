'use strict'

describe 'Controller: ReactionStatisticCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  ReactionStatisticCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ReactionStatisticCtrl = $controller 'ReactionStatisticCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
