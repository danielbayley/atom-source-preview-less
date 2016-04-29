[loophole, path, less, config, preview] = []

relative = ['.','..','../..']

module.exports =
class LessProvider
	fromScopeName: 'source.css.less'
	toScopeName: 'source.css'

	transform: (code, { filePath, sourceMap } = {}) ->
		less ?= @unsafe -> require 'less'
		{basename} = path ?= require 'path'
		{config: {includePaths}} = config ?= require '../package.json'

		options =
			filename: filePath.split(/[/]/).pop()
			paths: includePaths.concat relative, atom.project.getPaths()
			#rootpath:
			syncImport: true
			#relativeUrls:
			sourceMap: sourceMap # { sourceMapFullFilename: ''}
			#compress: false

		#less.logger.addListener error: (err) -> throw err
		less.render code, options, (err, css) ->
			throw err if err
			preview = css
		{
			code: @unsafe -> preview.css
			sourceMap: preview.map ? null
		}

	unsafe: (fn) ->
		loophole ?= require 'loophole'
		{allowUnsafeEval, allowUnsafeNewFunction} = loophole
		allowUnsafeNewFunction -> allowUnsafeEval -> fn()
