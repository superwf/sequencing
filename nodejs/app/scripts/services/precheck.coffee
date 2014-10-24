'use strict'
angular.module('sequencingApp').factory 'Precheck', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/prechecks/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/prechecks/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/prechecks/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    all: {isArray: true, method: 'GET'}
  }
]
