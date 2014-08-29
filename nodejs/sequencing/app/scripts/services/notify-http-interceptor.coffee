'use strict'

angular.module('sequencingApp').factory 'notifyHttpInterceptor', ['$q', '$location', '$rootScope', ($q, $location, $rootScope)->
  responseError: (rejection) ->
    status = rejection.status
    if status == 401
      $rootScope.$broadcast 'event:unauthorized'
    else
      $rootScope.$broadcast 'event:error', 'network error, error code is ' + status
    $q.reject rejection
  response: (response) ->
    if response.config.url.match /.json$/
      $rootScope.$broadcast 'event:loaded'
    response || $q.when(response)
  request: (config)->
    if config.url.match /.json$/
      $rootScope.$broadcast 'event:loading'
    config || $q.when(config)
]
