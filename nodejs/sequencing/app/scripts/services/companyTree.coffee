'use strict'
angular.module('sequencingApp').factory 'CompanyTree', ['map', '$resource', (map, $resource)->
  $resource map.api + '/companies/:id', id: '@id', {
    update: {method: 'PUT', url: map.api + '/companies/:id'}
    records: {isArray: true, method: 'GET', url: map.api + '/companyTree/:id'}
  }
]
