'use strict'
angular.module('sequencingApp').factory 'CompanyTree', ['map', '$http', (map, $http)->
  {
    records: (id)->
      $http.get map.api + '/company_tree/' + id
  }
]
