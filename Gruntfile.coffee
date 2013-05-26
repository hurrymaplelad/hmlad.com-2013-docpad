{exec} = require 'child_process'
{filterDev} = require 'matchdep'

module.exports = (grunt) ->
  # Load grunt plugins from devDependencies
  filterDev('grunt-*').forEach grunt.loadNpmTasks

  grunt.initConfig
    clean:
      out: ['out/']
      release: ['release/']

    connect:
      preview:
        options:
          base: 'release'

    copy:
      release:
        cwd: 'out/'
        src: [
          '**/index.html'
          'styles/**'
          'images/**'
          'favicon.png'
          'CNAME'
        ]
        dest: 'release/'
        expand: true

    docs: {}

    rename:
      release:
        files:
          'release/404.html': 'release/404/index.html'

    shell:
      options:
        stdout: true
        failOnError: true

      'fetchGHPages': 
        command: 'git fetch origin gh-pages'
        options:
          failOnError: false
      'makeReleaseDir':
        command: 'git clone . release'
      'checkoutGHPages':
        command: 'git checkout gh-pages || git checkout --orphan gh-pages'
        options: execOptions: cwd: 'release'
      'nukeReleaseDir':
        command: 'git rm -rfq .'
        options: execOptions: cwd: 'release'
      'stageReleaseDir':
        command: 'git add .'
        options: execOptions: cwd: 'release'

  grunt.registerTask 'generate', 
    'Render docpad documents in ./out',
    [
      'clean:out'
      'docs'
    ]

  grunt.registerTask 'dev',
    'Start a local development server',
    [
      'stage'
      'connect:preview:keepalive'
    ]

  grunt.registerTask 'stage', 
    'Stage a release build in ./release ready to be committed to the gh-pages branch', 
    [
      'generate'
      'clean:release'
      'shell:makeReleaseDir'
      'shell:checkoutGHPages'
      'shell:nukeReleaseDir'
      'copy:release'
      'rename:release'
      'shell:stageReleaseDir'
    ]

  grunt.registerTask 'assertNoUncommitedChanges', ->
    done = this.async()
    exec 'git status --porcelain', (err, stdout) ->
      if stdout
        grunt.warn 'Attempting to release uncommitted changes.'
      done()

  grunt.registerTask 'release',
    'Commit a release build to gh-pages and push to origin',
    [
      'assertNoUncommitedChanges'
      'shell:fetchGHPages'
      'stage'
      # 'captureCurrentRef'
      # 'shell:commitReleaseDir'
      # 'shell:pushGHPages'
    ]
