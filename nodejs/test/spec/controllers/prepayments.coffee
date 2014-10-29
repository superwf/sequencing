'use strict'

describe 'Controller: PrepaymentsCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  PrepaymentsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PrepaymentsCtrl = $controller 'PrepaymentsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
