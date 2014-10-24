'use strict'

describe 'Controller: OrderMailsCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  OrderMailsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    OrderMailsCtrl = $controller 'OrderMailsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
