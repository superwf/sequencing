'use strict'

angular.module('sequencingApp').factory 'SampleHead', ['map', '$resource', (map, $resource)->
  $resource map.api + '/sample_heads/:id', id: '@id', {
    update: {method: 'PUT', url: map.api + '/sample_heads/:id'}
    'delete': {method: 'DELETE', url: map.api + '/sample_heads/:id'}
    create: {method: 'POST'}
    query: {isArray: true, method: 'GET'}
  }
]
