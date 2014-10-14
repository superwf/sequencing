'use strict'
angular.module('sequencingApp').controller 'InterpreteCodesCtrl', ['$scope', 'InterpreteCode', 'Modal', '$modal', 'SequencingConst', 'BoardHead', ($scope, InterpreteCode, Modal, $modal, SequencingConst, BoardHead) ->
  $scope.interpreteCodeColor = SequencingConst.interpreteCodeColor
  InterpreteCode.query (data) ->
    $scope.records = data.records || []
    if $scope.records.length
      angular.forEach $scope.records, (v, i)->
        if v.board_head_id
          if SequencingConst.board_heads[v.board_head_id]
            v.board_head = SequencingConst.board_heads[v.board_head_id]
          else
            BoardHead.get id: v.board_head_id, (data)->
              v.board_head = data
    $scope.totalItems = data.totalItems
    $scope.perPage = data.perPage
    return
 
  $scope.delete = (id, index)->
    InterpreteCode.delete {id: id}
    $scope.records.splice index, 1

  $scope.create = ->
    Modal.record = {}
    $modal.open {
      templateUrl: '/views/interpreteCode.html'
      controller: 'InterpreteCodeCtrl'
    }
    .result.then (record)->
      $scope.records.unshift record

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/interpreteCode.html'
      controller: 'InterpreteCodeCtrl'
    }
]
