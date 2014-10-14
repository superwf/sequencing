'use strict'
angular.module('sequencingApp').controller 'InterpreteCodeCtrl', ['$scope', 'InterpreteCode', 'SequencingConst', 'Modal', 'BoardHead', ($scope, InterpreteCode, SequencingConst, Modal, BoardHead) ->
  $scope.results = SequencingConst.interpreteResult
  $scope.record = Modal.record
  BoardHead.all all: true, board_type: 'sample', (data)->
    $scope.board_heads = data
  $scope.board_heads

  if $scope.record.board_head_id
    BoardHead.get id: $scope.record.board_head_id, (data)->
      $scope.record.board_head = data

  $scope.save = ->
    if $scope.record.board_head
      $scope.record.board_head_id = $scope.record.board_head.id
    if $scope.record.id
      InterpreteCode.update $scope.record
    else
      InterpreteCode.create $scope.record, (data)->
        $scope.$close data
  null
]
