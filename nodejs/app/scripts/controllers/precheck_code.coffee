'use strict'
angular.module('sequencingApp').controller 'PrecheckCodeCtrl', ['$scope', 'PrecheckCode', 'SequencingConst', 'Modal', ($scope, PrecheckCode, SequencingConst, Modal) ->
  $scope.record = Modal.record

  $scope.save = ->
    if $scope.record.id
      PrecheckCode.update $scope.record, ->
        $scope.$close 'ok'
    else
      PrecheckCode.create $scope.record, (data)->
        $scope.record = data
        $scope.$close $scope.record
  null
]
