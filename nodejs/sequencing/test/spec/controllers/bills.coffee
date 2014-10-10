'use strict'

describe 'Controller: BillsCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  BillsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    BillsCtrl = $controller 'BillsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
