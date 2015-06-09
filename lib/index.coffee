###
#
# app/
#   - services/           ignored
#   - controllers/        ignored
#   - views/              ignored
#   - statics/            client-side copied assets
#   - assets/             client-side assets to be compiled/built
#     - scripts/            scripts (js, jsx, es6)
#       - <packageName>/    package -> built as <packageName>.js
#     - styles/           scripts (scss)
#       - <packageName>/    package -> built as <packageName>.css
#
#
# .public/                client-side resources
#   - javascripts/          scripts (js, es5)
#     - packageName.js        js package
#   - styles/               styles (css)
#     - packageName.css       css package
#
###

{getJoinToPathsHash, getGeneratedPackagesUrl} = require('./utils')

exports.getBrunchConfig = ->

  paths: public: '.public'

  conventions:

    # avoid server-side scripts from being compiled
    # to '.public/' folder
    ignored: [
      /^app\/(controllers|services)/          # ignore server-side scripts
      /[_]\w*\d*.scss/                        # restore sass conventions (do not compile _*.scss files)
    ]

    # override 'assets/' brunch convention
    # that contains files directly copied to '.public/''
    assets: /^statics[\\/]/

  modules:
    # Remove 'app/assets/scripts' from client-side modules references
    nameCleaner: (path) -> path.replace /^app\/assets\/scripts\//, ''

  files:

    javascripts:

      joinTo: getJoinToPathsHash(
        'app/assets/scripts',                 # path to scripts modules directories
        '^app\/assets\/scripts\/',            # start pattern of scripts modules directories
        'javascripts/',                       # public destination directory
        '.js'                                 # package extension
      )

      pluginHelpers: getGeneratedPackagesUrl( # inject auto-reload into main packages
        'app/assets/scripts',
        'javascripts/',
        '.js'
      )

    stylesheets:

      joinTo: getJoinToPathsHash(
        'app/assets/styles',                  # path to styles modules directories
        '^app\/assets\/styles\/',             # start pattern of style modules directories
        'styles/',                            # public destination directory
        '.css'                                # package extension
      )
