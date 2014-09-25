'use strict'

describe 'Controller: DilutePrimersCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  DilutePrimersCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    DilutePrimersCtrl = $controller 'DilutePrimersCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
