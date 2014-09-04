'use strict'
angular.module('sequencingApp').controller 'ProcedureCtrl', ['$scope', 'Procedure', '$routeParams', ($scope, Procedure, $routeParams) ->
  new_record = {
    flow_type: 'sample'
    board: false
    attachment: false
  }
  if $routeParams.id == 'new'
    $scope.record = new_record
  else
    $scope.record = Procedure.get id: $routeParams.id
  $scope.types = ['sample', 'reaction']
  $scope.ny = {true: 'yes', false: 'no'}

  $scope.save = ->
    if $scope.record.id
      $scope.record.$update id: $scope.record.id
    else
      Procedure.create $scope.record, (data)->
        $scope.record = data
  null
]
