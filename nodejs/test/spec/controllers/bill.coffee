'use strict'

describe 'Controller: BillCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  BillCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    BillCtrl = $controller 'BillCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
