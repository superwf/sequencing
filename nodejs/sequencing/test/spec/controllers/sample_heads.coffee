'use strict'

describe 'Controller: SampleHeadsCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  SampleHeadsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    SampleHeadsCtrl = $controller 'SampleHeadsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
