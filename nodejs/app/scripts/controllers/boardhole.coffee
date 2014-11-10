'use strict'
angular.module('sequencingApp').controller 'BoardHoleCtrl', ['BoardHead', 'Board', '$scope', 'Modal', '$rootScope', 'head', 'number','sn', (BoardHead, Board, $scope, Modal, $rootScope, head, number, sn) ->

  $scope.inModal = !!$scope.$close
  $scope.cols = head.cols.split(',')
  $scope.rows = head.rows.split(',')
  Board.holeRecords idsn: sn, (data)->
    if data
      $scope.boardRecords = {}
      angular.forEach data, (d)->
        $scope.boardRecords[d.hole] = d
  $scope.record = {sn: sn}

  $scope.board_head = head

  $scope.selectHole = (sn, hole, board_id)->
    if $scope.boardRecords && !$scope.boardRecords[hole]
      $scope.$close {sn: $scope.record.sn, hole: hole, board: $scope.board}
]
