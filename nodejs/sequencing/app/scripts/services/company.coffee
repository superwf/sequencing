'use strict'
angular.module('sequencingApp').factory 'Company', ['map', '$resource', (map, $resource)->
  $resource map.api + '/companies/:id', id: '@id', {
    update: {method: 'PUT', url: map.api + '/companies/:id'}
    'delete': {method: 'DELETE', url: map.api + '/companies/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
