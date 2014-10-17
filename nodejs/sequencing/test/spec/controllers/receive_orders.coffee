'use strict'

describe 'Controller: ReceiveOrdersCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  ReceiveOrdersCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ReceiveOrdersCtrl = $controller 'ReceiveOrdersCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
