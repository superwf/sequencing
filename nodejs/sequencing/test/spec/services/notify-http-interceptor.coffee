'use strict'

describe 'Service: notifyHttpInterceptor', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  notifyHttpInterceptor = {}
  $rootScope = null

  beforeEach inject (_notifyHttpInterceptor_, _$rootScope_) ->
    $rootScope = _$rootScope_
    notifyHttpInterceptor = _notifyHttpInterceptor_

  it 'test responseError', ->
    rejection = { status: 401 }
    spyOn $rootScope, '$broadcast'
    notifyHttpInterceptor.responseError rejection
    expect($rootScope.$broadcast).toHaveBeenCalledWith('event:unauthorized')

    rejection = { status: 400 }
    notifyHttpInterceptor.responseError rejection
    expect($rootScope.$broadcast).toHaveBeenCalledWith('event:error', 'network error, error code is 400')

  it 'test response', ->
    response = {
      config: {
        url: '/api/v1/a'
        method: 'GET'
      }
    }
    spyOn $rootScope, '$broadcast'
    notifyHttpInterceptor.response response
    expect($rootScope.$broadcast).toHaveBeenCalledWith('event:loaded')

  it 'test request', ->
    config = {
      url: '/api/v1/a'
      method: 'GET'
    }
    spyOn $rootScope, '$broadcast'
    notifyHttpInterceptor.request config
    expect($rootScope.$broadcast).toHaveBeenCalledWith('event:loading')
