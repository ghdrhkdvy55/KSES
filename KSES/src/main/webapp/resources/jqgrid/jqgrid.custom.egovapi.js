const _MainGridId = 'mainGrid';
const _MainPagerId = 'pager'
const _JqGridDelay = 500;
const _MainPagerSelector = '#'+_MainPagerId;
const MainGridSelector = '#'+_MainGridId;

$.EgovJqGridApi = function() {
	console.log('EgovJqGrid');
	this._jqGridParams;
};
/************************************************************************************************
 * Private 공통 함수
 * - 외부에서 호출하지 말것
 ************************************************************************************************/
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
$.EgovJqGridApi.prototype._formatter = function(colModel) {
	for (let col of colModel) {
		if (col.formatter === 'date') {
			col['formatoptions'] = { newformat: 'Y-m-d' };
		} else if (col.formatter === 'datetime') {
			col['formatter'] = 'date';
			col['formatoptions'] = { srcformat: 'Y-m-d H:i:s', newformat: 'Y-m-d H:i:s' }
		}
		if (col.sortable === undefined || col.sortable !== false || !col.hidden) {
			col['index'] = col.name;
		}
	}
};
$.EgovJqGridApi.prototype._getPage = function(id, pgButton, page, lastpage) {
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
const EgovJqGridApi = new $.EgovJqGridApi();
/************************************************************************************************
 * public 공통 함수
 ************************************************************************************************/
/**
 * jqGrid 그리드 선택
 * - multiselect 그리드는 사용하지 말것
 */
$.EgovJqGridApi.prototype.selection = function(id, rowId) {
	$('#'+id).jqGrid('resetSelection');
	if (rowId !== null && rowId !== undefined) {
		$('#'+id).jqGrid('setSelection', rowId);
	}
};
/**
 * jqGrid Default Editable Option
 */
$.EgovJqGridApi.prototype.getGridEditOption = function(num) {
	return {
		dataInit: function(el) {
			EgovIndexApi.numberOnly(el);
		},
		size: num,
		maxlength: num
	}
};
/**
 * jqGrid 그리드 RowData 가져오기
 */
$.EgovJqGridApi.prototype.getGridRowData = function(id, rowId) {
	return $('#'+id).jqGrid('getRowData', rowId);
};
/**
 * jqGrid 그리드 선택된 RowId 가져오기
 */
$.EgovJqGridApi.prototype.getGridSelectionId = function(id) {
	return $('#'+id).jqGrid('getGridParam', 'selrow');
};
/**
 * jqGrid 그리드 선택된 복수의 RowId 목록 가져오기
 */
$.EgovJqGridApi.prototype.getGridMutipleSelectionIds = function(id) {
	return $('#'+id).jqGrid('getGridParam', 'selarrrow');
};
/**
 * jqGrid 그리드 목록 초기화
 */
$.EgovJqGridApi.prototype.clearGrid = function(id) {
	$('#'+id).jqGrid('clearGridData');
};
/************************************************************************************************
 * public 메인 그리드 함수
 * - editable 가능
 * - multiselect 가능
 * - subgrid expend 가능
 * - resize 여부 추가
 ************************************************************************************************/
/**
 * JqGrid 메인 그리드 출력
 */
$.EgovJqGridApi.prototype.mainGrid = function(colModel, multiselect, subGrid, searchFunc, resize) {
	this._formatter(colModel);
	this._init('POST', colModel, multiselect, subGrid, false);
	this._jqGridParams['pager'] = $(_MainPagerSelector);
	let retGrid = $(MainGridSelector).jqGrid(this._jqGridParams);
	if (resize !== false) {
		$(window).bind('resize', function() {
			// 그리드의 width를 div 에 맞춰서 적용 
			$(MainGridSelector).setGridWidth($(MainGridSelector).closest('div.boardlist').width() , true);
		}).trigger('resize');
	}
	if (searchFunc) {
		setTimeout(function() { searchFunc(1) }, _JqGridDelay);
	}
	$('th#'+_MainGridId+'_rn').children('div:first').append('NO');
	return retGrid;
};
/**
 * JqGrid 메인 그리드 데이터 출력
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
			let mainGridParams = $(MainGridSelector).jqGrid('getGridParam');
			let page = mainGridParams['page'];
			let lastpage = mainGridParams['lastpage'];
			searchFunc(EgovJqGridApi._getPage(_MainGridId, pgButton, page, lastpage));
		},
	};
	if (subFunc) {
		jqGridParams['subGridRowExpanded'] = subFunc;
	}
	$(MainGridSelector).jqGrid('setGridParam', jqGridParams).trigger('reloadGrid');
};
/** JqGrid 메인 그리드 상세 팝업 호출 시
 *  - 사용 하지 않음
 */
$.EgovJqGridApi.prototype.mainGridDetail = function(detailFunc) {
	setTimeout(function() {
		$(MainGridSelector).jqGrid('setGridParam', {
			ondblClickRow: function(rowId, iRow, iCol, e) {
				if (!$(MainGridSelector).jqGrid('getInd', rowId)) {
					return false;
				} else {
					detailFunc(rowId, $(MainGridSelector).jqGrid('getRowData', rowId));
				}
			}
		});
	}, _JqGridDelay);
};
/**
 * jqGrid 메인 그리드 RowData 가져오기
 */
$.EgovJqGridApi.prototype.getMainGridRowData = function(rowId) {
	return $(MainGridSelector).jqGrid('getRowData', rowId);
};
/**
 * jqGrid 메인 그리드 선택된 하나의 RowId 가져오기
 */
$.EgovJqGridApi.prototype.getMainGridSingleSelectionId = function() {
	return $(MainGridSelector).jqGrid('getGridParam', 'selrow');
};
/**
 * jqGrid 메인 그리드 선택된 복수의 RowId 목록 가져오기
 * - jqGrid multiselect 시에 사용할 것
 */
$.EgovJqGridApi.prototype.getMainGridMutipleSelectionIds = function() {
	return $(MainGridSelector).jqGrid('getGridParam', 'selarrrow');
};
/************************************************************************************************
 * 서브 그리드 함수
 * - 메인그리드에서 expend 되어 출력되는 서브 그리드
 * - 페이징 세팅 없음
 * - selection 지원하지 않음
 ************************************************************************************************/
/**
 * JqGrid 서브 그리드 정의 및 출력
 */
$.EgovJqGridApi.prototype.subGrid = function(parentId, colModel, method, url, params) {
	let gridId = parentId + '_t';
	$('#'+parentId).empty().append('<table id="'+ gridId + '" class="scroll"></table>');
	this._formatter(colModel);
	this._init(method, colModel, false, false, true);
	this._jqGridParams['url'] = url;
	this._jqGridParams['postData'] = method === 'POST' ? JSON.stringify(params) : params;
	this._jqGridParams['jsonReader'] = { root: 'resultlist' };
	$('#'+gridId).jqGrid(this._jqGridParams);
	$('th#'+gridId+'_rn').children('div:first').append('NO');
};
/** JqGrid 서브 그리드 상세 팝업 호출 시  
 *  - 사용 하지 않음
 */
// $.EgovJqGridApi.prototype.subGridDetail = function(id, detailFunc) {
// 	setTimeout(function() {
// 		$('#'+id).jqGrid('setGridParam', {
// 			onSelectRow: function(rowId, iRow, iCol, e) {
// 				detailFunc(rowId, $('#'+id).jqGrid('getRowData', rowId));
// 			}
// 		});
// 	}, _JqGridDelay);
// };
/**
 * jqGrid 서브 그리드 변경 시 새로 고침
 */
$.EgovJqGridApi.prototype.subGridReload = function(parentId, subFunc) {
	setTimeout(function() {
		subFunc(_MainGridId+'_'+parentId, parentId);
	}, _JqGridDelay);
};
/**
 * jqGrid 서브 그리드 RowData 가져오기
 */
$.EgovJqGridApi.prototype.getSubGridRowData = function(parentId, rowId) {
	return $(MainGridSelector + '_' + parentId + '_t').jqGrid('getRowData', rowId);
};
/************************************************************************************************
 * public 페이징 그리드 함수
 * - paging 있음
 * - editable 가능
 * - subgrid expend 기능 없음
 * - resize 안됨
 ************************************************************************************************/
$.EgovJqGridApi.prototype.pagingGrid = function(id, colModel, pagerId, rowList, multiselect, rowNum) {
	this._formatter(colModel);
	this._init('POST', colModel, multiselect, false, false);
	this._jqGridParams['url'] = null;
	this._jqGridParams['pager'] = $('#'+ pagerId);
	this._jqGridParams['rowList'] = rowList === undefined ? [] : rowList;
	this._jqGridParams['rowNum'] = rowNum === undefined ? 10 : rowNum;
	let retGrid = $('#'+id).jqGrid(this._jqGridParams);
	$('th#'+id+'_rn').children('div:first').append('NO');
	return retGrid;
};
$.EgovJqGridApi.prototype.pagingGridAjax = function(id, url, params, searchFunc) {
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
			searchFunc(EgovJqGridApi._getPage(id, pgButton, page, lastpage));
		},
	};
	$('#'+id).jqGrid('setGridParam', jqGridParams).trigger('reloadGrid');
};
/************************************************************************************************
 * public 기본 그리드 함수
 * - paging 없음
 * - editable 가능
 * - subgrid expend 기능 없음
 * - resize 안됨
 ************************************************************************************************/
$.EgovJqGridApi.prototype.defaultGrid = function(id, colModel, multiselect) {
	this._formatter(colModel);
	this._init('POST', colModel, multiselect, false, false);
	this._jqGridParams['url'] = null;
	let retGrid = $('#'+id).jqGrid(this._jqGridParams);
	$('th#'+id+'_rn').children('div:first').append('NO');
	return retGrid;
};
$.EgovJqGridApi.prototype.defaultGridAjax = function(id, url, params, rowNum, callback) {
	let jqGridParams = {
		url: url,
		postData: JSON.stringify(params),
		rowNum: rowNum,
		loadComplete: function(data) {
			if (data.status === 'FAIL') {
				toastr.error(data.message);
				return false;
			}
			if (callback !== undefined && callback !== null) {
				callback(data.resultlist);
			}
		}
	};
	$('#'+id).jqGrid('setGridParam', jqGridParams).trigger('reloadGrid');
};
