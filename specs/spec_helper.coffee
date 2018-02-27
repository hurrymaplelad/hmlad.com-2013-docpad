chai = require 'chai'
asPromsed = require 'chai-as-promised'
settings = require '../settings'
puppeteer = require 'puppeteer'

chai
  .use asPromsed
  .should()

before ->
  @timeout 5000
  @baseUrl = settings.devServerUrl()
  puppeteer.launch(
    headless: false
    slowMo: 250
    executablePath: settings.chromePath
  ).then (browser) =>
    @browser = browser
    @browser.newPage().then (page) =>
      @page = page
      @page.on 'console', (msg) =>
        console.log '[BROWSER CONSOLE]:', msg.text()

after ->
  @browser.close()
