'use strict'

angular.module('sequencingApp').factory 'Board', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/boards/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/boards/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/boards/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    holeRecords: {isArray: true, method: 'GET', url: Sequencing.api + '/boardHoleRecords/:idsn'}
    confirm: {method: 'PUT', url: Sequencing.api + '/boards/:id/confirm'}
    retypeset: {method: 'PUT', url: Sequencing.api + '/retypesetBoard/:id'}
    nextProcedure: {method: 'PUT', url: Sequencing.api + '/boards/:id/nextProcedure'}
    typeseteReactionSampleBoards: {isArray: true, method: 'GET', url: Sequencing.api + '/typeset/reactionSampleBoards'}
    sampleBoardPrimers: {isArray: true, method: 'GET', url: Sequencing.api + '/sampleBoardPrimers/:id'}
  }
]
