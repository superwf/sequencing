'use strict'

describe 'Controller: TypesetSamplesCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  TypesetSamplesCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    TypesetSamplesCtrl = $controller 'TypesetSamplesCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
