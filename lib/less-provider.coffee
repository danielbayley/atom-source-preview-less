[loophole, less, config, preview] = []

module.exports =
class LessProvider

	fromGrammarName: 'Less'
	fromScopeName: 'source.css.less'
	toScopeName: 'source.css'

	relative: ['.','..','../..']
#-------------------------------------------------------------------------------

	unsafe: (fn) ->
		loophole ?= require 'loophole'
		{allowUnsafeEval, allowUnsafeNewFunction} = loophole
		allowUnsafeNewFunction -> allowUnsafeEval -> fn()

	transform: (code, { filePath, sourceMap } = {}) ->
		less ?= @unsafe -> require 'less'
		{config: {includePaths}} = config ?= require '../package.json'

		options =
			filename: filePath.split(/[/]/).pop()
			paths: includePaths.concat @relative, atom.project.getPaths()
			#rootpath:
			syncImport: true
			#relativeUrls:
			sourceMap: sourceMap # { sourceMapFullFilename: ''}
			#compress: false

		# TODO less.logger.addListener error: (err) -> throw err
		less.render code, options, (err, css) ->
			throw err if err
			preview = css

		code: @unsafe -> preview.css
		sourceMap: preview.map ? null
