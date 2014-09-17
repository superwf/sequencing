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
  'ui.date'
  'pascalprecht.translate'
  'ngSelectable'
]).config ['$routeProvider', '$locationProvider', '$httpProvider', '$translateProvider', ($routeProvider, $locationProvider, $httpProvider, $translateProvider) ->
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
    .when '/orders',
      templateUrl: 'views/orders.html',
      controller: 'OrdersCtrl'
    .when '/orders/:id',
      templateUrl: 'views/order.html',
      controller: 'OrderCtrl'
    .when '/primers',
      templateUrl: 'views/primers.html',
      controller: 'PrimersCtrl'
    .when '/primers/:id',
      templateUrl: 'views/primer.html',
      controller: 'PrimerCtrl'
    .when '/vectors',
      templateUrl: 'views/vectors.html',
      controller: 'VectorsCtrl'
    .when '/vectors/:id',
      templateUrl: 'views/vector.html',
      controller: 'VectorCtrl'
    .when '/boardHeads',
      templateUrl: 'views/boardHeads.html',
      controller: 'BoardHeadsCtrl'
    .when '/boardHeads/:id',
      templateUrl: 'views/boardHead.html',
      controller: 'BoardHeadCtrl'
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
    .when '/boards',
      templateUrl: 'views/boards.html',
      controller: 'BoardsCtrl'
    .when '/boards/:id',
      templateUrl: 'views/board.html',
      controller: 'BoardCtrl'
    .otherwise
      redirectTo: '/'
  $httpProvider.interceptors.push 'notifyHttpInterceptor'
]
