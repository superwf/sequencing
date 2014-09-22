'use strict'

angular.module('sequencingApp').controller 'ElectrosCtrl', ['$scope', 'Modal', 'SequencingConst', 'Electro', ($scope, Modal, SequencingConst, Electro) ->
  $scope.board = Modal.board

  $scope.record = {remark: 'ok', board_id: $scope.board.id}

  $scope.save = ->
    Electro.create $scope.record, (electro)->
      $scope.$close electro
]
