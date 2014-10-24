'use strict'

angular.module('sequencingApp').controller 'CompanyCtrl', ['$scope', 'Company', '$routeParams', '$modal', 'Modal', '$rootScope', ($scope, Company, $routeParams, $modal, Modal, $rootScope) ->
  if $routeParams.id == 'new'
    $scope.record = {}
  else
    if Modal.record
      $scope.record = Modal.record
    else
      Company.get id: $routeParams.id, (data)->
        $scope.record = data
        if data.parent_id > 0
          Company.get id: $scope.record.parent_id, (parent)->
            $scope.parent = parent.name

  $scope.save = ->
    $scope.record.price = $scope.record.price * 1
    if $scope.record.id > 0
      Company.update $scope.record
    else
      Company.create $scope.record, (data)->
        $scope.record.id = data.id
    if $scope['$close']
      $scope.$close 'ok'
    null
  $scope.showParent = ()->
    Modal.resource = Company
    modal = $modal.open {
      templateUrl: '/views/companiesTable.html'
      controller: 'ModalTableCtrl'
      resolve:
        searcher: ->
          {}
    }
    modal.result.then (data)->
      $scope.record.parent = data.name
      $scope.record.parent_id = data.id
      null

  null
]
