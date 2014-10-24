'use strict'
angular.module('sequencingApp').factory 'BoardRecord', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/boardRecords/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/boardRecords/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/boardRecords/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
