'use strict'

angular.module('sequencingApp').factory 'Sample', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/samples/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/samples/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/samples/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    typesettingHeads: {isArray: true, method: 'GET', url: Sequencing.api + '/typesetting/sampleHeads'}
    typesetting: {isArray: true, method: 'GET', url: Sequencing.api + '/typesetting/samples'}
    typeset: {method: 'PUT', url: Sequencing.api + '/typeset/samples'}
  }
]
