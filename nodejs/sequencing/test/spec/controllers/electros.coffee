'use strict'

describe 'Controller: ElectrosCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  ElectrosCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ElectrosCtrl = $controller 'ElectrosCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
