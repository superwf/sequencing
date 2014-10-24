'use strict'
angular.module('sequencingApp').factory 'BillRecord', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/billRecords/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/billRecords/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/billRecords/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
