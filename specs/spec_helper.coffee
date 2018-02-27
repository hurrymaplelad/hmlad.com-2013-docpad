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
  @browser = await puppeteer.launch
    headless: !settings.bugLike
    slowMo: settings.bugLike == 'creeper' ? 400 : undefined
    executablePath: settings.chromePath
  @page = await @browser.newPage()
  @page.on 'console', (msg) =>
    console.log '[BROWSER CONSOLE]:', msg.text()

after ->
  if settings.bugLike
    console.log 'Leaving window open for debugging'
  else
    @browser.close()
