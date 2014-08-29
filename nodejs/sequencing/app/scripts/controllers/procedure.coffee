'use strict'
angular.module('sequencingApp').controller 'ProcedureCtrl', ['$scope', 'Procedure', '$routeParams', ($scope, Procedure, $routeParams) ->
  $scope.record = Procedure.get id: $routeParams.id
  $scope.types = ['sample', 'reaction']
  #$scope.ny = ['no', 'yes']
  $scope.ny = {true: 'yes', false: 'no'}

  $scope.save = ->
    if $scope.record.id
      $scope.record.$update id: $scope.record.id
    else
      $scope.record.$create()
  null
]
