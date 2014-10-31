'use strict'
angular.module('sequencingApp').controller 'BoardHeadCtrl', ['$scope', '$routeParams', 'Modal', '$modal', 'BoardHead', 'Sequencing', 'Procedure', 'Flow', ($scope, $routeParams, Modal, $modal, BoardHead, Sequencing, Procedure, Flow) ->
  $scope.boardType = Sequencing.boardType
  $scope.record = Modal.record
  Procedure.all {all: true, board_head_id: $scope.record.id}, (data)->
    $scope.procedures = data

  $scope.save = ->
    if $scope.record.id
      BoardHead.update $scope.record, ->
        $scope.$close 'ok'
    else
      BoardHead.create $scope.record, (data)->
        $scope.$close data

  $scope.showProcedure = ()->
    Modal.resource = Procedure
    $modal.open {
      templateUrl: '/views/procedures.html'
      controller: 'ModalTableCtrl'
      resolve:
        searcher: ->
          {all: true, flow_type: $scope.record.board_type}
    }
    .result.then (data)->
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
