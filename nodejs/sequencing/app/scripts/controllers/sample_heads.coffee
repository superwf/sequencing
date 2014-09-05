'use strict'
angular.module('sequencingApp').controller 'SampleHeadsCtrl', ['$scope', 'SampleHead', 'map', ($scope, SampleHead, map) ->
  SampleHead.query (data) ->
    $scope.records = data.records
    $scope.totalItems = data.totalItems
    $scope.perPage = data.perPage
    return
  $scope.yesno = map.yesno
 
  $scope.delete = (id, index)->
    SampleHead.delete {id: id}
    $scope.records.splice index, 1
]
