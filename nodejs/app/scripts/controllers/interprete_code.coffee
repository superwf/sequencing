'use strict'
angular.module('sequencingApp').controller 'InterpreteCodeCtrl', ['$scope', 'InterpreteCode', 'Sequencing', 'Modal', 'BoardHead', ($scope, InterpreteCode, Sequencing, Modal, BoardHead) ->
  $scope.inModal = !!$scope.$close

  $scope.results = Sequencing.interpreteResult
  $scope.record = Modal.record
  BoardHead.all all: true, board_type: 'sample', (data)->
    $scope.board_heads = data
    return

  $scope.board_heads

  if $scope.record.board_head_id
    $scope.record.board_head = Sequencing.boardHeads[$scope.record.board_head_id]

  $scope.save = ->
    if $scope.record.board_head
      $scope.record.board_head_id = $scope.record.board_head.id
    if $scope.record.id
      InterpreteCode.update $scope.record, ->
        $scope.$close 'ok'
    else
      InterpreteCode.create $scope.record, (data)->
        $scope.$close data
    return
  null
]
