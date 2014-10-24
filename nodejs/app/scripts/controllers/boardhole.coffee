'use strict'
angular.module('sequencingApp').controller 'BoardHoleCtrl', ['BoardHead', 'Board', '$scope', 'Modal', '$rootScope', 'head', 'number','sn', (BoardHead, Board, $scope, Modal, $rootScope, head, number, sn) ->
  $scope.cols = head.cols.split(',')
  $scope.rows = head.rows.split(',')
  Board.records idsn: sn, (data)->
    if data
      $scope.boardRecords = {}
      angular.forEach data, (d)->
        $scope.boardRecords[d.hole] = d
  $scope.sn = sn

  $scope.selectHole = (sn, hole, board_id)->
    if $scope.boardRecords && !$scope.boardRecords[hole]
      $scope.$close {sn: sn, hole: hole, board: $scope.board}
]
