const _MainGridId = 'mainGrid';
const _MainPagerId = 'pager'
const _JqGridDelay = 500;
const _MainGridSelector = '#'+_MainGridId, _MainPagerSelector = '#'+_MainPagerId;

$.EgovJqGridApi = function() {
	console.log('EgovJqGrid');
	this._jqGridParams;
};
/** JqGrid 공통 Param 생성 
	(외부 호출 함수 아님) 
*/
$.EgovJqGridApi.prototype._init = function(mtype, colModel, multiselect, subGrid, loadonce) {
	this._jqGridParams = {
		mtype: mtype,		
		colModel: colModel,
		datatype: 'json',
		ajaxGridOptions: { 
			contentType: 'application/json; charset=UTF-8'
		},
		loadBeforeSend: function(xhr, settings){
			xhr.setRequestHeader('AJAX', 'true');
		},
		rowNum: 10,
		rowList: [10,20,30,40,50,100],
		rownumbers: true,
		autowidth: true,
		height: '100%',
		shrinkToFit: true,
		loadtext: '데이터를 가져오는 중...',
		emptyrecords: '조회된 데이터가 없습니다',			
		jsonReader: {
			root: 'resultlist',
			page: 'paginationInfo.currentPageNo',
			total: 'paginationInfo.totalPageCount',
			records: 'paginationInfo.totalRecordCount',
			repeatitems: false
		},
		multiselect: multiselect,
		subGrid: subGrid,
		loadonce: loadonce,
		loadError: function(xhr, status) {
			EgovIndexApi._apiResponseException(xhr);
		}
	};
};
/** JqGrid Param 재 정의 
	(외부 호출 함수 아님) 
*/
$.EgovJqGridApi.prototype._formatter = function(colModel) {
	for (let col of colModel) {
		if (col.formatter === 'date') {
			col['formatoptions'] = { newformat: 'Y-m-d' };
		}
		if (col.sortable === undefined || col.sortable !== false || !col.hidden) {
			col['index'] = col.name;
		}
	}
};
/** JqGrid 페이징 정의
 */
$.EgovJqGridApi.prototype.getPage = function(id, pgButton, page, lastpage) {
	let ret;
	switch (pgButton) {
		case 'next':
			ret = page < lastpage ? page+1 : page;
			break;
		case 'prev':
			ret = page > 1 ? page-1 : page;
			break;
		case 'first':
			ret = 1;
			break;
		case 'last':
			ret = lastpage;
			break;
		case 'user':
			let now = Number($('#'+ id +' .ui-pg-input').val());
			ret = lastpage >= now && now > 0 ? now : page;
			$('#'+ id +' .ui-pg-input').val(page);
			break;
		case 'records':
			ret = 1;
			break;
		default:
	}
	return ret;
};
/** JqGrid 메인 그리드 출력 
	- 출력 후 자동 검색 함수 호출
 */
$.EgovJqGridApi.prototype.mainGrid = function(colModel, multiselect, subGrid, searchFunc, resize) {
	this._formatter(colModel);
	this._init('POST', colModel, multiselect, subGrid, false);
	this._jqGridParams['pager'] = $(_MainPagerSelector);
	let retGrid = $(_MainGridSelector).jqGrid(this._jqGridParams);
	if (resize !== false) {
		$(window).bind('resize', function() {
			// 그리드의 width를 div 에 맞춰서 적용 
			$(_MainGridSelector).setGridWidth($(_MainGridSelector).closest('div.boardlist').width() , true);
		}).trigger('resize');
	}
	if (searchFunc) {
		setTimeout(function() { searchFunc(1) }, _JqGridDelay);
	}
	$('th#'+_MainGridId+'_rn').children('div:first').append('NO');
	return retGrid;
};
/** JqGrid 메인 그리드 검색 함수에서 필요한 데이터 호출 함수 
	- 페이징 정의
	- 서브 그리드 필요 여부
*/
$.EgovJqGridApi.prototype.mainGridAjax = function(url, params, searchFunc, subFunc) {
	let jqGridParams = {
		url: url,
		postData: JSON.stringify(params),
		loadComplete: function(data) {
			if (data.status === 'FAIL') {
				toastr.error(data.message);
				return false;				
			}
			$('#sp_totcnt').html(data.paginationInfo.totalRecordCount);	
		},
		onPaging: function(pgButton) {
			let mainGridParams = $(_MainGridSelector).jqGrid('getGridParam');
			let page = mainGridParams['page'];
			let lastpage = mainGridParams['lastpage'];
			searchFunc(EgovJqGridApi.getPage(_MainGridId, pgButton, page, lastpage));
		},
	};
	if (subFunc) {
		jqGridParams['subGridRowExpanded'] = subFunc;
	}
	$(_MainGridSelector).jqGrid('setGridParam', jqGridParams).trigger('reloadGrid');
};
/** JqGrid 서브 그리드 정의 및 출력 */
$.EgovJqGridApi.prototype.subGrid = function(id, colModel, method, url, params) {
	this._formatter(colModel);
	this._init(method, colModel, false, false, true);
	this._jqGridParams['url'] = url;
	this._jqGridParams['postData'] = method === 'POST' ? JSON.stringify(params) : params;
	this._jqGridParams['jsonReader'] = { root: 'resultlist' };
	$('#'+id).jqGrid(this._jqGridParams);
	$('th#'+id+'_rn').children('div:first').append('NO');
};
/** JqGrid 메인 그리드 상세 팝업 호출 시  */
$.EgovJqGridApi.prototype.mainGridDetail = function(detailFunc) {
	setTimeout(function() {
		$(_MainGridSelector).jqGrid('setGridParam', { 
			ondblClickRow: function(rowId, iRow, iCol, e) {
				if (!$(_MainGridSelector).jqGrid('getInd', rowId)) {
					return false;
				} else {
					detailFunc(rowId, $(_MainGridSelector).jqGrid('getRowData', rowId));
				}
			} 
		});
	}, _JqGridDelay);
};
/** JqGrid 서브 그리드 상세 팝업 호출 시  */
$.EgovJqGridApi.prototype.subGridDetail = function(id, detailFunc) {
	setTimeout(function() {
		$('#'+id).jqGrid('setGridParam', { 
			onSelectRow: function(rowId, iRow, iCol, e) {
				detailFunc(rowId, $('#'+id).jqGrid('getRowData', rowId));
			}
		});
	}, _JqGridDelay);
};

$.EgovJqGridApi.prototype.subGridReload = function(rowId, subFunc) {
	setTimeout(function() {
		subFunc(_MainGridId+'_'+rowId, rowId);	
	}, _JqGridDelay);
};

$.EgovJqGridApi.prototype.popGrid = function(id, colModel, pagerId, rowList) {
	this._formatter(colModel);
	this._init('POST', colModel, false, false, false);
	this._jqGridParams['url'] = null;
	this._jqGridParams['pager'] = $('#'+ pagerId);
	this._jqGridParams['rowList'] = rowList === undefined ? [] : rowList;
	let retGrid = $('#'+id).jqGrid(this._jqGridParams);
	$('th#'+id+'_rn').children('div:first').append('NO');
	return retGrid;
};

$.EgovJqGridApi.prototype.popGridAjax = function(id, url, params, searchFunc) {
	let jqGridParams = {
		url: url,
		postData: JSON.stringify(params),
		loadComplete: function(data) {
			if (data.status === 'FAIL') {
				toastr.error(data.message);
				return false;				
			}
		},
		onPaging: function(pgButton) {
			let gridParams = $('#'+id).jqGrid('getGridParam');
			let page = gridParams['page'];
			let lastpage = gridParams['lastpage'];
			searchFunc(EgovJqGridApi.getPage(id, pgButton, page, lastpage));
		},
	};
	$('#'+id).jqGrid('setGridParam', jqGridParams).trigger('reloadGrid');
};

$.EgovJqGridApi.prototype.selection = function(id, rowId) {
	$('#'+id).jqGrid('resetSelection');
	if (rowId !== null && rowId !== undefined) {
		$('#'+id).jqGrid('setSelection', rowId);
	}
};

const EgovJqGridApi = new $.EgovJqGridApi();