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
    .when '/roles',
      templateUrl: 'views/roles.html',
      controller: 'RolesCtrl'
    .when '/roles/:id',
      templateUrl: 'views/role.html',
      controller: 'RoleCtrl'
    .when '/company_root',
      templateUrl: 'views/companyRoot.html',
      controller: 'CompanyTreeCtrl'
    .when '/companies',
      templateUrl: 'views/companies.html',
      controller: 'CompaniesCtrl'
    .when '/companies/:id',
      templateUrl: 'views/company.html',
      controller: 'CompanyCtrl'
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
