'use strict'

angular.module('sequencingApp').factory 'Security', ['$modal', '$location', '$http', '$q', 'Sequencing', ($modal, $location, $http, $q, Sequencing)->
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
      $http(method: 'POST', url: Sequencing.auth + '/login', data: user)
    logout: (redirectTo)->
      $http(method: 'DELETE', url: Sequencing.auth + '/logout').then ->
        service.me = null
        redirect redirectTo
    requestCurrentUser: ->
      if service.isAuthenticated()
        $q.when(service.me)
      else
        $http.get(Sequencing.auth + '/me').then (response)->
          service.me = response.data
          service.me
    me: null,
    isAuthenticated: ->
      !!service.me
  }
  service
]
