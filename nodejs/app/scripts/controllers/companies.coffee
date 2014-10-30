'use strict'

angular.module('sequencingApp').controller 'CompaniesCtrl', ['$scope', 'Company', ($scope, Company) ->
  $scope.inModal = !!$scope.$close
  if !$scope.inModal
    $scope.$emit 'event:title', 'company'
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
