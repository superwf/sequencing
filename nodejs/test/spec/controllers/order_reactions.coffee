'use strict'

describe 'Controller: OrderReactionsCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  OrderReactionsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    OrderReactionsCtrl = $controller 'OrderReactionsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
