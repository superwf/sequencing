'use strict'

describe 'Controller: ShakeBacsCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  ShakeBacsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ShakeBacsCtrl = $controller 'ShakeBacsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
