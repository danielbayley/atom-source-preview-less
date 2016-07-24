preview = null

module.exports =
	activate: ->

		fromGrammarName: 'Less'
		fromScopeName: 'source.css.less'
		toScopeName: 'source.css'

		include: ['lib','styles','less','css']
			#'assets/styles'
			#'assets/less'
			#'assets/css'
			#'partials'
			#'modules'
			#'mixins'
			#'helpers'
		#]
#-------------------------------------------------------------------------------
		unsafe: (fn) ->
			loophole = require 'loophole'
			{allowUnsafeEval, allowUnsafeNewFunction} = loophole
			allowUnsafeNewFunction -> allowUnsafeEval -> fn()

		transform: (code, { filePath, sourceMap }) ->
			less = @unsafe -> require 'less'

			options =
				filename: filePath?.split('/').pop()
				paths: @include.concat atom.project.getPaths()
				#rootpath:
				syncImport: true
				#relativeUrls:
				sourceMap: sourceMap # { sourceMapFullFilename:''}
				#compress: false

			less.render code, options, (err, css) ->
			#less.logger.addListener error: (err) -> throw err
				throw err if err
				preview = css

			code: @unsafe -> preview.css
			sourceMap: preview.map ? null
