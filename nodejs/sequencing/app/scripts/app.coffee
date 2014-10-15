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
    .when '/orders/newRework',
      templateUrl: 'views/reworkOrder.html',
      controller: 'ReworkOrderCtrl'
    .when '/orders/:id',
      templateUrl: 'views/order.html',
      controller: 'OrderCtrl'
    .when '/primers',
      templateUrl: 'views/primers.html',
      controller: 'PrimersCtrl'
    .when '/vectors',
      templateUrl: 'views/vectors.html',
      controller: 'VectorsCtrl'
    .when '/boardHeads',
      templateUrl: 'views/boardHeads.html',
      controller: 'BoardHeadsCtrl'
    .when '/clients',
      templateUrl: 'views/clients.html',
      controller: 'ClientsCtrl'
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
    .when '/plasmidCodes',
      templateUrl: 'views/plasmidCodes.html',
      controller: 'PlasmidCodesCtrl'
    .when '/precheckCodes',
      templateUrl: 'views/plasmidCodes.html',
      controller: 'PrecheckCodesCtrl'
    .when '/interpreteCodes',
      templateUrl: 'views/interpreteCodes.html',
      controller: 'InterpreteCodesCtrl'
    .when '/dilutePrimers',
      templateUrl: 'views/dilutePrimers.html',
      controller: 'DilutePrimersCtrl'
    .when '/typeset/reactions',
      templateUrl: 'views/typesetReactions.html',
      controller: 'TypesetReactionsCtrl'
    .when '/reactionFiles',
      templateUrl: 'views/reactionFiles.html',
      controller: 'ReactionFilesCtrl'
    .when '/sendOrderEmails',
      templateUrl: 'views/orderEmails.html',
      controller: 'OrderEmailsCtrl'
    .when '/emails',
      templateUrl: 'views/emails.html',
      controller: 'EmailsCtrl'
    .when '/bills',
      templateUrl: 'views/bills.html',
      controller: 'BillsCtrl'
    .otherwise
      redirectTo: '/'
  $httpProvider.interceptors.push 'notifyHttpInterceptor'
]
