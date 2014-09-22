'use strict'
angular.module('sequencingApp').controller 'ShakeBacsCtrl', ['$scope', 'Modal', 'SequencingConst', 'ShakeBac', ($scope, Modal, SequencingConst, ShakeBac) ->
  $scope.board = Modal.board

  $scope.record = {remark: 'ok', board_id: $scope.board.id}

  $scope.save = ->
    ShakeBac.create $scope.record, (electro)->
      $scope.$close electro
]
