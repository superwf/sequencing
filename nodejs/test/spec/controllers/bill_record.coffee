'use strict'

describe 'Controller: BillRecordCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  BillRecordCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    BillRecordCtrl = $controller 'BillRecordCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
