'use strict'
angular.module('sequencingApp').factory 'Company', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/companies/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/companies/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/companies/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
