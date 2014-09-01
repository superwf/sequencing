'use strict'

describe 'Directive: notifyFlash', ->

  # load the directive's module
  beforeEach module 'sequencingApp'

  scope = {}
  element = null
  $rootScope = null

  beforeEach inject ($controller, _$rootScope_, $compile) ->
    $rootScope = _$rootScope_
    scope = $rootScope.$new()
    element = angular.element '<div notify-flash=""></div>'
    element = $compile(element) scope
    scope = element.scope()

  it 'when rootScope broadcast event:error', ->
    $rootScope.$broadcast 'event:error', 'abc'
    expect(scope.level).toEqual('danger')
    expect(scope.msg).toEqual('abc')

  it 'when rootScope broadcast event:loading, event:loaded', ->
    $rootScope.$broadcast 'event:loading'
    expect(scope.level).toEqual('info')
    expect(scope.msg).toEqual('loading')

    $rootScope.$broadcast 'event:loaded'
    expect(scope.msg).toBeNull()

  it 'close method', ->
    scope.msg = 'abc'
    scope.close()
    expect(scope.msg).toBeNull()
