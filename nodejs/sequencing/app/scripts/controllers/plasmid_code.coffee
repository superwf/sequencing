'use strict'
angular.module('sequencingApp').controller 'PlasmidCodeCtrl', ['$scope', 'PlasmidCode', 'SequencingConst', 'Modal', ($scope, PlasmidCode, SequencingConst, Modal) ->
  $scope.record = Modal.record

  $scope.save = ->
    if $scope.record.id
      PlasmidCode.update $scope.record, ->
        $scope.$close 'ok'
    else
      PlasmidCode.create $scope.record, (data)->
        $scope.$close data
  null
]
