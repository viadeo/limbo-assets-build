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

{getGeneratedPackagesUrl, PathsHash} = require('./utils')

###
# generates a JS packages definition from scritps folders, e.g.
#
# {
#   'javascripts/nico.js':      /^app/assets/scripts/nico/,
#   'javascripts/otherPage.js': /^app/assets/scripts/otherPage/,
#   'javascripts/page.js':      /^app/assets/scripts/page/
# }
#
###
getJavascriptsHash = -> new PathsHash(
  'app/assets/scripts',                 # path to scripts modules directories
  '^app\/assets\/scripts\/',            # start pattern of scripts modules directories
  'javascripts/',                       # public destination directory
  '.js'                                 # package extension
)

getStylesHash = -> new PathsHash(
  'app/assets/styles',                  # path to styles modules directories
  '^app\/assets\/styles\/',             # start pattern of style modules directories
  'styles/',                            # public destination directory
  '.css'                                # package extension
)

exports.getBrunchConfig = ->

  paths: public: '.public'

  conventions:

    # avoid server-side scripts from being compiled
    # to '.public/' folder
    ignored: [
      /^app\/(controllers|services|views)/    # ignore server-side scripts
      /[_]\w*\d*.scss/                        # ignore _*.scss files, restoring sass conventions
    ]

    # override 'assets/' brunch convention
    # that contains files directly copied to '.public/''
    assets: /^statics[\\/]/

  modules:
    # Remove 'app/assets/scripts' from client-side modules references
    nameCleaner: (path) -> path.replace /^app\/assets\/scripts\//, ''

  files:

    javascripts:

      joinTo: getJavascriptsHash().setAdditional('javascripts/vendor.js', /^bower_components/)

      pluginHelpers: 'javascripts/vendor.js' # inject live-reload plugin into vendor package

    templates: joinTo: getJavascriptsHash()

    stylesheets: joinTo: getStylesHash()

  plugins:

    handlebars:
      include:
        enabled: false
