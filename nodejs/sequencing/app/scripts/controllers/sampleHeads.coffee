'use strict'
angular.module('sequencingApp').controller 'SampleHeadsCtrl', ['$scope', 'SampleHead', ($scope, SampleHead) ->
  SampleHead.query (data) ->
    $scope.records = data.records
    $scope.totalItems = data.totalItems
    $scope.perPage = data.perPage
    return
 
  $scope.delete = (id, index)->
    SampleHead.delete {id: id}
    $scope.records.splice index, 1
]
