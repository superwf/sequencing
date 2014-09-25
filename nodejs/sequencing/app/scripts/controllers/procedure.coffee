'use strict'
angular.module('sequencingApp').controller 'ProcedureCtrl', ['$scope', 'Procedure', 'Modal', ($scope, Procedure, Modal) ->
  $scope.record = Modal.record
  $scope.types = ['sample', 'reaction']

  $scope.save = ->
    if $scope.record.id
      $scope.record.$update id: $scope.record.id
      $scope.$close 'ok'
    else
      Procedure.create $scope.record, (data)->
        $scope.$close data
  null
]
