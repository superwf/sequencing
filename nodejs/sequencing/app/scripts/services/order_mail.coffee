'use strict'
angular.module('sequencingApp').factory 'OrderMail', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/orderMails/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/orderMails/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/orderMails/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    sending: {isArray: true, url: SequencingConst.api + '/sendingOrderMails'}
    submitInterpretedReactionFiles: {method: 'PUT', url: SequencingConst.api + '/submitInterpretedReactionFiles'}
  }
]
