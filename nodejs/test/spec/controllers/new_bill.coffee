'use strict'

describe 'Controller: NewBillCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  NewBillCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    NewBillCtrl = $controller 'NewBillCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
