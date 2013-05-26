module.exports = (grunt) ->
  {exec} = require 'child_process'

  grunt.initConfig
    clean:
      out: ['out/']
      release: ['release/']

    copy:
      release:
        cwd: 'out/'
        src: [
          '**/index.html'
          'images/**'
          'favicon.png'
          'styles/**'
        ]
        dest: 'release/'
        expand: true

    docs: {}

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

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-docs'
  grunt.loadNpmTasks 'grunt-shell'

  grunt.registerTask 'generate', 
    'Render docpad documents into out',
    [
      'clean:out'
      'docs'
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
