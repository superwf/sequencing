'use strict'

describe 'Controller: PrepaymentCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  PrepaymentCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PrepaymentCtrl = $controller 'PrepaymentCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
