'use strict'
angular.module('sequencingApp').factory 'Procedure', ['map', '$resource', (map, $resource)->
  $resource map.api + '/procedures/:id', id: '@id', {
    update: {method: 'PUT', url: map.api + '/procedures/:id'}
    'delete': {method: 'DELETE', url: map.api + '/procedures/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
