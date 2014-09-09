'use strict'
angular.module('sequencingApp').factory 'Client', ['map', '$resource', (map, $resource)->
  $resource map.api + '/clients/:id', id: '@id', {
    update: {method: 'PUT', url: map.api + '/clients/:id'}
    'delete': {method: 'DELETE', url: map.api + '/clients/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
