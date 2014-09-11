'use strict'
angular.module('sequencingApp').factory 'Client', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/clients/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/clients/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/clients/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
