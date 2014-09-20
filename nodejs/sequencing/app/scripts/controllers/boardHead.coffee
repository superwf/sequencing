'use strict'
angular.module('sequencingApp').controller 'BoardHeadCtrl', ['$scope', '$routeParams', 'Modal', '$modal', 'BoardHead', 'SequencingConst', 'Procedure', 'Flow', ($scope, $routeParams, Modal, $modal, BoardHead, SequencingConst, Procedure, Flow) ->
  $scope.boardType = SequencingConst.boardType
  if $routeParams.id == 'new'
    $scope.record = with_date: true, available: true
  else
    if Modal.record
      $scope.record = Modal.record
    else
      $scope.record = BoardHead.get id: $routeParams.id
    Procedure.all {all: true, board_head_id: $scope.record.id}, (data)->
      $scope.procedures = data

  $scope.save = ->
    if $scope.record.id
      BoardHead.update $scope.record
    else
      BoardHead.create $scope.record, (data)->
        $scope.record = data
    if Modal.modal
      Modal.modal.close 'ok'

  $scope.showProcedure = ()->
    Modal.resource = Procedure
    modal = $modal.open {
      templateUrl: '/views/procedures.html'
      controller: 'ModalTableCtrl'
      resolve:
        searcher: ->
          {all: true, flow_type: $scope.record.board_type}
    }
    modal.result.then (data)->
      $scope.procedure = data
      null

  $scope.addProcedure = ->
    if $scope.procedure
      Flow.create {procedure_id: $scope.procedure.id, board_head_id: $scope.record.id}, (data)->
        $scope.procedures.push $scope.procedure

  $scope.deleteProcedure = (id, index)->
    Flow.delete {id: id}, ()->
      $scope.procedures.splice index, 1
  null
]
