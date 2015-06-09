fs = require('fs')
path = require('path')

getDirectories = (srcPath) ->
  fs.readdirSync(srcPath).filter (file) ->
    fs.statSync(path.join(srcPath, file)).isDirectory()

getJoinToPath = (dirName, srcRegexpPattern, destPath, extension) ->
  result =
    bundle: path.join(destPath, dirName) + extension
    srcRegexp: new RegExp(srcRegexpPattern + dirName)
  return result

exports.getJoinToPathsHash = (srcPath, srcRegexpPattern, destPath, extension) ->

  iteratee = {}

  iterator = (pkgName) ->
    pkgSpec = getJoinToPath(pkgName, srcRegexpPattern, destPath, extension)
    iteratee[pkgSpec.bundle] = pkgSpec.srcRegexp

  getDirectories(srcPath).forEach(iterator)

  return iteratee

exports.getGeneratedPackagesUrl = (srcPath, destPath, ext) ->
  getDirectories(srcPath).map (dir) -> "#{path.join(destPath, dir)}#{ext}"
