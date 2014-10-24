'use strict'

describe 'Controller: MainCtrl', ->

  beforeEach(module('sequencingApp'))

  MainCtrl = null
  scope = null
  Security = null
  $rs = null

  beforeEach inject ($controller, $rootScope, _Security_)->
    $rs = $rootScope
    Security = _Security_
    spyOn Security, 'showLogin'
    spyOn Security, 'logout'
    scope = $rootScope.$new()
    MainCtrl = $controller('MainCtrl', {
      $scope: scope
    })

  it 'should has title', ->
    expect(scope.title).toBe('sequencing')

  it 'on event:unauthorized', ->
    expect(Security.modal).toBeNull()
    scope.$broadcast 'event:unauthorized'
    expect(Security.showLogin).toHaveBeenCalled()

  it 'on event:authorized', ->
    me = 'hello me'
    scope.$broadcast 'event:authorized', me
    expect(scope.me).toEqual me

  it 'has logout, showLogin methods', ->
    scope.showLogin()
    expect(Security.showLogin).toHaveBeenCalled()
    listener = jasmine.createSpy 'listener'
    $rs.$on 'event:logout', listener
    scope.logout()
    expect(listener).toHaveBeenCalled()
    expect(Security.logout).toHaveBeenCalled()
