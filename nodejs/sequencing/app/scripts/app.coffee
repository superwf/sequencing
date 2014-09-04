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
]).constant('map': {
  'api': '/api/v1'
  'yesno': {true: 'yes', false: 'no'}
}).config ['$routeProvider', '$locationProvider', '$httpProvider', '$translateProvider', ($routeProvider, $locationProvider, $httpProvider, $translateProvider) ->
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
    .when '/sample_heads',
      templateUrl: 'views/sample_heads.html',
      controller: 'SampleHeadsCtrl'
    .when '/sample_heads/:id',
      templateUrl: 'views/sample_head.html',
      controller: 'SampleHeadCtrl'
    .otherwise
      redirectTo: '/'
  $httpProvider.interceptors.push 'notifyHttpInterceptor'
]
