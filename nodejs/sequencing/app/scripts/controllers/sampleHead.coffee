'use strict'
angular.module('sequencingApp').controller 'SampleHeadCtrl', ['$scope', 'SampleHead', 'map', '$routeParams', ($scope, SampleHead, map, $routeParams) ->
  new_record = {
    auto_precheck: false
    available: true
  }
  if $routeParams.id == 'new'
    $scope.record = new_record
  else
    $scope.record = SampleHead.get id: $routeParams.id
  $scope.yesno = map.yesno

  $scope.save = ->
    if $scope.record.id
      $scope.record.$update id: $scope.record.id
    else
      SampleHead.create $scope.record, (data)->
        $scope.record = data
  null
]
