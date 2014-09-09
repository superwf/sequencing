'use strict'

angular.module('sequencingApp').factory 'SampleHead', ['map', '$resource', (map, $resource)->
  $resource map.api + '/sampleHeads/:id', id: '@id', {
    update: {method: 'PUT', url: map.api + '/sampleHeads/:id'}
    'delete': {method: 'DELETE', url: map.api + '/sampleHeads/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
