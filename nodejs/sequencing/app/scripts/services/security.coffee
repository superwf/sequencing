'use strict'

angular.module('sequencingApp').factory 'Security', ['$modal', '$location', '$http', '$q', 'map', ($modal, $location, $http, $q, map)->
  redirect = (url)->
    url = url || '/'
    $location.path url

  service = {
    modal: null,
    showLogin: ->
      service.modal = $modal.open {
        templateUrl: '/views/login.html',
        controller: 'LoginCtrl'
      }
      service.modal
    cancel: ->
      service.modal.dismiss('cancel')
      service.modal = null
      redirect()
    login: (user)->
      $http(method: 'POST', url: map.api + '/login', data: user)
    logout: (redirectTo)->
      $http(method: 'DELETE', url: map.api + '/logout').then ->
        service.me = null
        redirect redirectTo
    requestCurrentUser: ->
      if service.isAuthenticated()
        $q.when(service.me)
      else
        $http.get(map.api + '/me').then (response)->
          service.me = response.data
          service.me
    me: null,
    isAuthenticated: ->
      !!service.me
  }
  service
]
