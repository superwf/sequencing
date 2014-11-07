'use strict'

describe 'Controller: AttachmentCtrl', ->

  # load the controller's module
  beforeEach module 'sequencingApp'

  AttachmentCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AttachmentCtrl = $controller 'AttachmentCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
