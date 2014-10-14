'use strict'

angular.module('sequencingApp').factory 'Email', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/emails/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/emails/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/emails/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
