'use strict'

describe 'Controller: PrecheckCodesCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  PrecheckCodesCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PrecheckCodesCtrl = $controller 'PrecheckCodesCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
