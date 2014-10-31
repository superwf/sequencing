'use strict'

angular.module('sequencingApp').controller 'VectorCtrl', ['$scope', 'Vector', 'Sequencing', 'Modal', ($scope, Vector, Sequencing, Modal) ->
  $scope.inModal = !!$scope.$close
  $scope.record = Modal.record
  $scope.save = ->
    if $scope.record.id
      Vector.update $scope.record, ->
        if $scope.inModal
          $scope.$close 'ok'
    else
      Vector.create $scope.record, (data)->
        $scope.$close data
  null
]
