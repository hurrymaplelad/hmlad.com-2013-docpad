require './spec_helper'

describe 'post listings page', ->
  before ->
    @page.goto @baseUrl

  it 'has a title', ->
    @page.title().should.become 'HurryMapleLad'
