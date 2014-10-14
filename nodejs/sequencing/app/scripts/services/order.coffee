'use strict'

angular.module('sequencingApp').factory 'Order', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/orders/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/orders/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/orders/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    interpretedReactionFiles: {isArray: true, url: SequencingConst.api + '/interpretedReactionFiles/:id'}
    reinterprete: {method: 'PUT', url: SequencingConst.api + '/reinterprete'}
    submitInterpretedReactionFiles: {method: 'PUT', url: SequencingConst.api + '/submitInterpretedReactionFiles'}
    sending: {isArray: true, url: SequencingConst.api + '/sendingOrderEmails'}
  }
]
