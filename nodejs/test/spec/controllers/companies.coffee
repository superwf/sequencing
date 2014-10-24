'use strict'

describe 'Controller: CompaniesCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  CompaniesCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    CompaniesCtrl = $controller 'CompaniesCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
