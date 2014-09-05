'use strict'

angular.module('sequencingApp').controller 'CompanyCtrl', ['$scope', 'Company', '$routeParams', '$modal', ($scope, Company, $routeParams, $modal) ->
  new_record = {
  }
  if $routeParams.id == 'new'
    $scope.record = new_record
  else
    $scope.record = Company.get id: $routeParams.id

  $scope.save = ->
    $scope.record.price = $scope.record.price * 1
    if $scope.record.id
      $scope.record.$update id: $scope.record.id
    else
      Company.create $scope.record, (data)->
        $scope.record = data
  $scope.showParent = ()->
    $modal.open {
      templateUrl: '/views/companies.html'
      controller: 'CompaniesCtrl'
      resolve:
        inModal: ->
          true
    }
  null
]
