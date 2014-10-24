'use strict'

describe 'Controller: SampleHeadCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  SampleHeadCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    SampleHeadCtrl = $controller 'SampleHeadCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
