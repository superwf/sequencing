'use strict'
angular.module('sequencingApp').controller 'PrimerHeadCtrl', ['$scope', '$routeParams', 'Modal', 'PrimerHead', 'map', ($scope, $routeParams, Modal, PrimerHead, map) ->
  if $routeParams.id == 'new'
    $scope.record = with_date: true, available: true
  else
    if Modal.record
      $scope.record = Modal.record
    else
      $scope.record = PrimerHead.get id: $routeParams.id
  $scope.yn = map.yesno

  $scope.save = ->
    if $scope.record.id
      PrimerHead.update $scope.record
    else
      PrimerHead.create $scope.record, (data)->
        $scope.record = data

  $scope.showCompany = ()->
    Modal.resource = Company
    Modal.modal = $modal.open {
      templateUrl: '/views/companiesTable.html'
      controller: 'ModalCtrl'
    }

  null
]
