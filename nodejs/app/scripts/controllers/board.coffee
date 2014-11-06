'use strict'

angular.module('sequencingApp').controller 'BoardCtrl', ['$scope', 'Board', 'Sequencing', '$routeParams', 'Modal', 'BoardHead', ($scope, Board, Sequencing, $routeParams, Modal, BoardHead) ->
  $scope.inModal = !!$scope.$close
  if Modal.record
    $scope.record = Modal.record
  else
    Board.get id: $routeParams.id, (data)->
      $scope.record = data
  $scope.board_head = Sequencing.boardHeads[$scope.record.board_head_id]
  $scope.cols = $scope.board_head.cols.split ','
  $scope.rows = $scope.board_head.rows.split ','

  Board.holeRecords idsn: $scope.record.sn, (data)->
    if data
      $scope.boardRecords = {}
      angular.forEach data, (d)->
        $scope.boardRecords[d.hole] = d
  null
]
