'use strict'

angular.module('sequencingApp', [
  'ngAnimate'
  'ngCookies'
  'ngResource'
  'ngRoute'
  'ngSanitize'
  'ngTouch'
  'ui.bootstrap'
  'pascalprecht.translate'
]).constant('api', '/api/v1').config ['$routeProvider', '$locationProvider', '$httpProvider', '$translateProvider', ($routeProvider, $locationProvider, $httpProvider, $translateProvider) ->
  $translateProvider.preferredLanguage 'cn'
  $translateProvider.useStaticFilesLoader {
    prefix: '/scripts/'
    suffix: '.json'
  }
  $locationProvider.html5Mode(true)
  $routeProvider
    .when '/',
      templateUrl: 'views/home.html',
      controller: 'HomeCtrl'
    .when '/procedures',
      templateUrl: 'views/procedures.html',
      controller: 'ProceduresCtrl'
    .when '/procedures/:id',
      templateUrl: 'views/procedure.html',
      controller: 'ProcedureCtrl'
    .otherwise
      redirectTo: '/'
  $httpProvider.interceptors.push 'notifyHttpInterceptor'
]
