##
#
# Conventions
# -----------
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
##

PathsHash = require('./utils/PathsHash')

##
# Conventions Constants
##

SCRIPTS_SRC               = 'app/assets/scripts'
SCRIPTS_PATH_REGEXP_TPL   = '^app\/assets\/scripts\/'
SCRIPTS_PUBLIC_FOLDER     = 'javascripts/'
SCRIPTS_PUBLIC_EXTENSION  = '.js'

STYLES_SRC                = 'app/assets/styles'
STYLES_PATH_REGEXP_TPL    = '^app\/assets\/styles\/'
STYLES_PUBLIC_FOLDER      = 'styles/'
STYLES_PUBLIC_EXTENSION   = '.css'

VENDOR_PATH_REGEXP        = /^bower_components/
VENDOR_SCRIPTS_SRC        = 'javascripts/vendor.js'
VENDOR_STYLES_SRC         = 'styles/vendor.css'

##
# Hash Factories
##

getJavascriptsHash = -> new PathsHash(
  SCRIPTS_SRC,
  SCRIPTS_PATH_REGEXP_TPL,
  SCRIPTS_PUBLIC_FOLDER,
  SCRIPTS_PUBLIC_EXTENSION
)

getStylesHash = -> new PathsHash(
  STYLES_SRC,
  STYLES_PATH_REGEXP_TPL,
  STYLES_PUBLIC_FOLDER,
  STYLES_PUBLIC_EXTENSION
)

##
# Brunch generated configuration
##

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

  modules: nameCleaner: (path) -> path.replace(new RegExp(SCRIPTS_PATH_REGEXP_TPL), '') # Remove 'app/assets/scripts' from client-side modules references

  files:

    javascripts:
      joinTo: getJavascriptsHash().setAdditional(VENDOR_SCRIPTS_SRC, VENDOR_PATH_REGEXP)
      pluginHelpers: VENDOR_SCRIPTS_SRC # inject live-reload plugin into vendor package

    templates: joinTo: getJavascriptsHash()
    stylesheets: joinTo: getStylesHash().setAdditional(VENDOR_STYLES_SRC, VENDOR_PATH_REGEXP)

  plugins: handlebars: include: enabled: false
