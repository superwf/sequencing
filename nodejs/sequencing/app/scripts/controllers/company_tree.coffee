'use strict'

angular.module('sequencingApp').controller 'CompanyTreeCtrl', ['$scope', 'CompanyTree', 'Company', ($scope, CompanyTree, Company) ->
  CompanyTree.records(0).then (data)->
    $scope.record =
      children: data.data
    return

  $scope.expand = (record)->
    if record.children_count > 0
      if !record.children || record.children.length == 0
        CompanyTree.records(record.id).then (data)->
          record.children = data.data
      else
        record.children = []
    null
  $scope.delete = (record)->
    Company.delete {id: record.id}
    record.deleted = true
  null
]
