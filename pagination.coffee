# Pagination.coffee - A jQuery Pagination Plugin
# Pagination.coffee - jQuery分页插件
# 
# Author Xiaohang Yu
# 作者  于晓航
# 
# On Aug. 3rd, 2015

# Helper functions
# 工具函数
countLength = (obj) ->
	count = 0
	for i in obj
		count++ if obj.hasOwnProperty(i)
	count

# Pagination class definition
# 分页类定义
class Pagination

	# Constructor
	# 构造器
	constructor: (options) ->
		@options = options
		@remote = options.remote
		@url = if @remote then options.url else ''
		@values = if options.values then options.values else []
		@method = if options.method then options.method else 'GET'
		@width = options.width
		@height = options.height
		@limit = options.limit
		@headerRow = options.headerRow
		@buttons = if options.buttons then options.buttons else {}
		@maxPage = if Math.ceil(@values.length / @limit) is 0 then 1 else Math.ceil(@values.length / @limit)
		@pageIds = []
		@buttonIds = []
		retrieve() if @remote

	# Helper functions
	# 工具函数
	getStartingIndex: (pageNum) -> (pageNum - 1) * @limit

	# Retrieve information
	# 获取数据
	retrieve: () ->
		$.ajax(
			url: @url
			method: @method
			success: (data, textStatus, jqXHR) ->
				@values = data
				@maxPage = Math.ceil(data.length / @limit)
				return
		)

	setValues: (val) ->
		@values = val
		return

	# Inflate current data to table
	# 填充数据
	inflate: (jqObj, pageNum) ->
		return if pageNum < 1 or pageNum > @maxPage
		startingIdx = this.getStartingIndex(pageNum)

		# Clear
		# 清空之前值
		jqObj.empty()

		self = this
		table = $('<table class="table" id="pagination-table"><thead><tr></tr></thead><tbody></tbody></table>')
		bar = $('<div class="pagination pagination-centered" id="pagination-bar"><ul></ul></div>')

		## Clear old data and handlers
		## 清空旧值及监听器
		$(document.body).undelegate('#prev', 'click')
		$(document.body).undelegate('#next', 'click')
		for i in @pageIds
			$(document.body).undelegate(i, 'click')
		@pageIds = []
		for j in @buttonIds
			$(document.body).undelegate(j, 'click')
		@buttonIds = []

		# Inflate header row
		# 生成标题栏
		theadrow = table.children('thead').children('tr')
		theadrow.append('<th></th>')
		$.each(@headerRow, (idx, e) ->
			theadrow.append($('<th>').text(e))
			return
		)
		theadrow.append('<th></th>') if countLength(@buttons) isnt 0

		# Inflate body values
		# 填充行数据
		thisPage = @values[startingIdx..startingIdx + @limit - 1]
		uid = 0
		$.each(thisPage, (idx, eachObj) ->
			row = $('<tr>').append('<td><input type="checkbox" class="rowSelect" /></td>')
			row.data('id', eachObj.id)
			row.data('rowData', eachObj.data)
			$.each(eachObj.data, (idx, eachCell) ->
				row.append($('<td>').text(eachCell))
			)
			$.each(self.buttons, (name, handler) ->
				buttonId = "button-#{uid++}"
				row.append("<td><button class=\"btn btn-small\" id=#{buttonId}>#{name}</button></td>")
				$(document.body).on('click', "##{buttonId}", (e) ->
					e.preventDefault()
					parentRow = $(this).parent().parent()
					handler(parentRow.data('id'), parentRow.data('rowData'))
					return
				)
				self.buttonIds.push("##{buttonId}")
				return
			)
			table.children('tbody').append(row)
			return
		)
		
		# Create pagination bar
		# 创建分页条

		## Previous page
		## 上一页
		bar.children('ul').append('<li><a href="javascript:void(0);" id="prev">&laquo;</a></li>');
		$(document.body).on('click', '#prev', (e) ->
			e.preventDefault()
			$('#pagination-table').parent().paginate('inflate', pageNum - 1)
			return
		)

		## Page numbers
		## 页码
		for i in [1..@maxPage]
			bar.children("ul").append("<li><a href=\"javascript:void(0);\" id=\"to-page-#{i}\">#{i}</a></li>")
			$(document.body).delegate("#to-page-#{i}", 'click', (e) ->
				e.preventDefault()
				$('#pagination-table').parent().paginate('inflate', i)
				return
			)
			self.pageIds.push("#to-page-#{i}")

		## Next page
		## 下一页
		bar.children('ul').append('<li><a href="javascript:void(0);" id="next">&raquo;</a></li>')
		$(document.body).on('click', '#next', (e) ->
			e.preventDefault()
			$('#pagination-table').parent().paginate('inflate', pageNum + 1)
			return
		)

		## Set selected
		## 设置按钮已选状态
		$("to-page-#{pageNum}").addClass('disabled')

		# Add to DOM
		# 填充至DOM
		jqObj.append(table)
		jqObj.append(bar)

# Define plugin function in jQuery
# 在jQuery中定义插件函数
`
$.fn.paginate = function (options) {
	if (typeof(pg) !== "undefined") {
		if (options === "get") {
			return pg;
		}
		else if (options === "inflate") {
			pg.inflate(this, arguments[1]);
			return this;
		}
		else if (options === "setValues") {
			pg.setValues(arguments[1]);
		}
	}
	pg = new Pagination(options);
	pg.inflate(this, 1);
	return this;
}`