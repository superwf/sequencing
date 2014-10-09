'use strict'

describe 'Service: orderMail', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  orderMail = {}
  beforeEach inject (_orderMail_) ->
    orderMail = _orderMail_

  it 'should do something', ->
    expect(!!orderMail).toBe true
