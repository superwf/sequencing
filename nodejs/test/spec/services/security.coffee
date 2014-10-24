'use strict'

describe 'Service: Security', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  Security = {}
  $httpBackend = null
  $modal = null
  api = '/api/v1'

  beforeEach inject (_Security_, _$httpBackend_, _$modal_) ->
    $httpBackend = _$httpBackend_
    $httpBackend.when('GET', '/scripts/cn.json').respond({})
    Security = _Security_
    $modal = _$modal_
    spyOn($modal, 'open').and.callThrough()

  it 'has modal', ->
    expect(Security.modal).toBeNull()

  it 'when showLogin, modal is not null, when cancel, set modal null', ->
    Security.showLogin()
    expect(Security.modal).not.toBeNull()
    spyOn(Security.modal, 'dismiss').and.returnValue('')
    Security.cancel()
    expect(Security.modal).toBeNull()

  it 'when login, post /login and return a promise', ->
    $httpBackend.when('POST', api + '/login').respond('')
    expect(Security.login({email: 'a@b.com'}).then).toBeDefined()

  it 'when logout, delete /logout', ->
    Security.me = {name: 'aaa'}
    $httpBackend.when('DELETE', api + '/logout').respond('')
    Security.logout()
    $httpBackend.flush()
    expect(Security.me).toBeNull()

  it 'requestCurrentUser', ->
    user = {name: 'admin'}
    $httpBackend.when('GET', api + '/me').respond(user)
    Security.requestCurrentUser()
    $httpBackend.flush()
    expect(Security.me).toEqual(user)
