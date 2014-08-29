'use strict'

###*
 # @ngdoc function
 # @name sequencingApp.controller:ProceduresCtrl
 # @description
 # # ProceduresCtrl
 # Controller of the sequencingApp
###
angular.module('sequencingApp').controller 'ProceduresCtrl', ['$scope', 'Procedure', ($scope, Procedure) ->
  Procedure.query (data) ->
    $scope.records = data
    return
 
  $scope.delete = (id, index)->
    Procedure.delete {id: id}
    $scope.records.splice index, 1
]
