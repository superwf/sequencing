'use strict'
angular.module('sequencingApp').controller 'BoardHeadCtrl', ['$scope', '$routeParams', 'Modal', '$modal', 'BoardHead', 'SequencingConst', 'Procedure', ($scope, $routeParams, Modal, $modal, BoardHead, SequencingConst, Procedure) ->
  $scope.boardType = SequencingConst.boardType
  if $routeParams.id == 'new'
    $scope.record = with_date: true, available: true
  else
    if Modal.record
      $scope.record = Modal.record
    else
      $scope.record = BoardHead.get id: $routeParams.id

  $scope.save = ->
    if $scope.record.id
      BoardHead.update $scope.record
    else
      BoardHead.create $scope.record, (data)->
        $scope.record = data
    if Modal.modal
      Modal.modal.dismiss 'cancel'

  $scope.showProcedure = ()->
    Modal.resource = Procedure
    modal = $modal.open {
      templateUrl: '/views/procedures.html'
      controller: 'ModalTableCtrl'
      resolve:
        searcher: ->
          {}
    }
    modal.result.then (data)->
      $scope.procedure = data
      null

  $scope.addProcedure = ->
    $scope.procedure
  null
]
