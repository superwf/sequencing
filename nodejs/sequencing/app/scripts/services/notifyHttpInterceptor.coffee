'use strict'

angular.module('sequencingApp').factory 'notifyHttpInterceptor', ['$q', '$location', '$rootScope', ($q, $location, $rootScope)->
  responseError: (rejection) ->
    status = rejection.status
    if status == 401
      $rootScope.$broadcast 'event:unauthorized'
    else if status == 406
      $rootScope.$broadcast 'event:notacceptable', rejection.data
    else
      $rootScope.$broadcast 'event:error', 'network error, error code is ' + status
    $q.reject rejection
  response: (response) ->
    #if response.config.url.match /^\/api\/v1/ || response.config.method == 'GET'
    if response.config.method == 'GET'
      $rootScope.$broadcast 'event:loaded'
    else if response.config.method == 'PUT'
      $rootScope.$broadcast 'event:ok', 'updatedOK'
    else if response.config.method == 'POST'
      $rootScope.$broadcast 'event:ok', 'createdOK'
    else if response.config.method == 'DELETE'
      $rootScope.$broadcast 'event:ok', 'deletedOK'
    response || $q.when(response)
  request: (config)->
    apimatch = /^\/api\/v1/
    if apimatch.test(config.url) && config.method == 'GET'
      $rootScope.$broadcast 'event:loading'
    config || $q.when(config)
]
