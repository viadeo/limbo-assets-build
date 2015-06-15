fs = require('fs')
path = require('path')
_ = require('lodash')

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

getDirectories = (srcPath) ->
  fs.readdirSync(srcPath).filter (file) ->
    fs.statSync(path.join(srcPath, file)).isDirectory()



getJoinToPath = (dirName, srcRegexpPattern, destPath, extension) ->
  result =
    bundle: path.join(destPath, dirName) + extension
    srcRegexp: new RegExp(srcRegexpPattern + dirName)
  return result



getJoinToPathsHash = (srcPath, srcRegexpPattern, destPath, extension) ->
  iteratee = {}
  iterator = (pkgName) ->
    pkgSpec = getJoinToPath(pkgName, srcRegexpPattern, destPath, extension)
    iteratee[pkgSpec.bundle] = pkgSpec.srcRegexp
  getDirectories(srcPath).forEach(iterator)
  return iteratee



exports.getGeneratedPackagesUrl = (srcPath, destPath, ext) ->
  getDirectories(srcPath).map (dir) -> "#{path.join(destPath, dir)}#{ext}"


class PathsHash

  constructor: ->
    _.merge(this, getJoinToPathsHash.apply(this, arguments))

  setAdditional : (key, value) ->
    this[key] = value
    this

exports.PathsHash = PathsHash
