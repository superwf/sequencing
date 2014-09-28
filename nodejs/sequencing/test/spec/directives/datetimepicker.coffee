'use strict'

describe 'Directive: datetimepicker', ->

  # load the directive's module
  beforeEach module 'sequencingApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<datetimepicker></datetimepicker>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the datetimepicker directive'
