'use strict'

describe 'Controller: EmailsCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  EmailsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    EmailsCtrl = $controller 'EmailsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
