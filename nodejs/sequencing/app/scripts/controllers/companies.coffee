'use strict'

angular.module('sequencingApp').controller 'CompaniesCtrl', ['$scope', 'Company', ($scope, Company) ->
  $scope.inModal = false
  $scope.searcher = {}
  $scope.search = ->
    Company.query $scope.searcher, (data) ->
      $scope.records = data.records
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      return
  $scope.search()
  $scope.setPage = ()->
    $scope.search()
 
]
