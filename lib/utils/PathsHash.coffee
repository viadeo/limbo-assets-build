fs = require('fs')
path = require('path')
_ = require('lodash')

getDirectories = (srcPath) ->
  fs.readdirSync(srcPath).filter (file) -> fs.statSync(path.join(srcPath, file)).isDirectory()

getJoinToPathsHash = (srcPath, srcRegexpTemplate, destPath, extension) ->
  getDirectories(srcPath).reduce(
    (acc, pkgName) ->
      acc[path.join(destPath, pkgName) + extension] = new RegExp(srcRegexpTemplate + pkgName)
      acc
    {}
  )

###
# generates a JS packages definition from scripts folders, e.g.
#
# {
#   'javascripts/nico.js':      /^app/assets/scripts/nico/,
#   'javascripts/otherPage.js': /^app/assets/scripts/otherPage/,
#   'javascripts/page.js':      /^app/assets/scripts/page/
# }
#
###

class PathsHash

  constructor: ->
    _.merge(this, getJoinToPathsHash.apply(this, arguments))

  setAdditional : (key, value) ->
    this[key] = value
    this

module.exports = PathsHash
