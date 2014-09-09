'use strict'

angular.module('sequencingApp', [
  'ngAnimate'
  'ngCookies'
  'ngResource'
  'ngRoute'
  'ngSanitize'
  'ngTouch'
  'ui.bootstrap'
  'ui.drop'
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
    .when '/primerBoards',
      templateUrl: 'views/primerBoards.html',
      controller: 'PrimerBoardsCtrl'
    .when '/primerBoards/:id',
      templateUrl: 'views/primerBoard.html',
      controller: 'PrimerBoardCtrl'
    .when '/primerHeads',
      templateUrl: 'views/primerHeads.html',
      controller: 'PrimerHeadsCtrl'
    .when '/primerHeads/:id',
      templateUrl: 'views/primerHead.html',
      controller: 'PrimerHeadCtrl'
    .when '/clients',
      templateUrl: 'views/clients.html',
      controller: 'ClientsCtrl'
    .when '/clients/:id',
      templateUrl: 'views/client.html',
      controller: 'ClientCtrl'
    .when '/companyRoot',
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
    .when '/sampleHeads',
      templateUrl: 'views/sampleHeads.html',
      controller: 'SampleHeadsCtrl'
    .when '/sampleHeads/:id',
      templateUrl: 'views/sampleHead.html',
      controller: 'SampleHeadCtrl'
    .otherwise
      redirectTo: '/'
  $httpProvider.interceptors.push 'notifyHttpInterceptor'
]
