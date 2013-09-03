{filterDev} = require 'matchdep'
inquirer = require 'inquirer'

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
          '!**/20??-??-??-*/index.html'
          'styles/**'
          'images/**'
          'favicon.png'
          'rss.xml'
          'CNAME'
        ]
        dest: 'release/'
        expand: true

    docs: {}

    open:
      preview:
        path: 'http://localhost:8000'

    rename:
      release:
        files:
          'release/404.html': 'release/404/index.html'

    shell:
      options:
        stdout: true
        failOnError: true

      fetchGHPages:
        command: 'git fetch origin gh-pages'
        options:
          failOnError: false
      makeReleaseDir:
        command: 'git clone . release'
      checkoutGHPages:
        command: 'git checkout gh-pages || git checkout --orphan gh-pages'
        options: execOptions: cwd: 'release'
      nukeReleaseDir:
        command: 'git rm -rfq .'
        options: execOptions: cwd: 'release'
      stageReleaseDir:
        command: 'git add .'
        options: execOptions: cwd: 'release'
      assertNoUncommitedChanges:
        command: 'git status --porcelain'
        options:
          stdout: false
          callback: (err, stdout, stderr, done) ->
            if err ?= stderr
              grunt.fatal err
            if stdout
              grunt.warn "Attempting to release uncommitted changes: \n#{stdout}"
            done()
      captureCurrentRef:
        command: 'echo "$(git symbolic-ref --short HEAD):$(git log -1 --format=%h)"'
        options:
          stdout: false
          callback: (err, stdout, stderr, done) ->
            if err ?= stderr
              grunt.fatal err
            grunt.config.set 'currentRef', stdout
            done()
      commitReleaseDir:
        command: 'git commit -m"Released from <%= currentRef %>"'
        options: execOptions: cwd: 'release'
      pushGHPages:
        command: 'git fetch release gh-pages:gh-pages && git push origin gh-pages'

    watch:
      docpad:
        files: 'src/**/*.md'
        tasks: [
          'generate'
          'copy:release'
          'rename:release'
        ]

    new:
      post:
        template: 'generators/templates/post.ld'
        data: (done) ->
          inquirer.prompt [name: 'title', message: 'Title'], (answers) ->
            title = answers.title
            date = grunt.template.today 'yyyy-mm-dd'
            slug = grunt.util._.dasherize title.toLowerCase()
            done null,
              title: title
              dest: "src/documents/#{date}-#{slug}.html.md"

  grunt.registerTask 'generate',
    'Render docpad documents in ./out',
    [
      'clean:out'
      'docs'
    ]

  grunt.registerTask 'dev',
    'Start a local development server',
    [
      'clean'
      'shell:makeReleaseDir'
      'shell:checkoutGHPages'
      'generate'
      'copy:release'
      'rename:release'
      'connect:preview'
      'open:preview'
      'watch'
    ]

  grunt.registerTask 'stage',
    'Stage a release build in ./release ready to be committed to the gh-pages branch',
    [
      'clean'
      'shell:makeReleaseDir'
      'shell:checkoutGHPages'
      'shell:nukeReleaseDir'
      'generate'
      'copy:release'
      'rename:release'
      'shell:stageReleaseDir'
    ]

  grunt.registerTask 'release',
    'Commit a release build to gh-pages and push to origin',
    [
      'shell:assertNoUncommitedChanges'
      'shell:fetchGHPages'
      'stage'
      'shell:captureCurrentRef'
      'shell:commitReleaseDir'
      'shell:pushGHPages'
    ]
