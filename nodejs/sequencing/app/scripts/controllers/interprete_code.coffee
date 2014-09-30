'use strict'
angular.module('sequencingApp').controller 'InterpreteCodeCtrl', ['$scope', 'InterpreteCode', 'SequencingConst', '$routeParams', 'Modal', ($scope, InterpreteCode, SequencingConst, $routeParams, Modal) ->
  $scope.results = SequencingConst.interpreteResults
  $scope.record = Modal.record
  $scope.save = ->
    if $scope.record.id
      InterpreteCode.update $scope.record
    else
      InterpreteCode.create $scope.record, (data)->
        $scope.$close data
  null
]
