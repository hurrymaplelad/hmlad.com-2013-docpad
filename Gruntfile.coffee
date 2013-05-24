module.exports = (grunt) ->
  {exec} = require 'child_process'

  grunt.initConfig
    clean:
      release: ['release']

    copy:
      release:
        cwd: 'out/'
        src: '**/index.html'
        dest: 'release/'
        expand: true

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
  grunt.loadNpmTasks 'grunt-shell'

  grunt.registerTask 'stage', 
    'Stage a release build in ./release ready to be committed to the gh-pages branch', 
    [
      'clean:release'
      'shell:fetchGHPages'
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
      'stage'
    ]
