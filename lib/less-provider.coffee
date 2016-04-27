[loophole, less, preview] = []

module.exports =
class LessProvider
	fromScopeName: 'source.css.less'
	toScopeName: 'source.css'

	transform: (code, {sourceMap} = {}) -> #filePath

		less ?= @unsafe -> require 'less'

		options =
			filename: atom.workspace.getActiveTextEditor().getTitle() #filePath
			paths: ['.','./lib'].concat atom.project.getPaths()
			#rootpath:
			syncImport: true
			#relativeUrls:
			sourceMap: { sourceMapFullFilename: sourceMap }
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
