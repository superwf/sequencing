'use strict'

angular.module('sequencingApp').factory 'sampleHead', ['api', '$resource', (api, $resource)->
  $resource api + '/sample_heads/:id', id: '@id', {
    update: {method: 'PUT', url: api + '/sample_heads/:id'}
    'delete': {method: 'DELETE', url: api + '/sample_heads/:id'}
    create: {method: 'POST'}
    query: {isArray: true, method: 'GET'}
  }
]
