'use strict'

describe 'Controller: ReactionsCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  ReactionsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ReactionsCtrl = $controller 'ReactionsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
