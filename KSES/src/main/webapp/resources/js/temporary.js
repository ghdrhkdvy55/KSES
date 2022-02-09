$.EgovIndexApi = function() {
	console.log('EgovIndexApi');
	let jqXhr;
};

$.EgovIndexApi.prototype.camelToUnderscore = function(key) {
	let result = key.replace( /([A-Z])/g, " $1" );
	return result.split(' ').join('_').toLowerCase();
};

$.EgovIndexApi.prototype.getUrlParameter = function(name) {
	let sParameterName, i;
	let sPageURL = decodeURIComponent(window.location.search.substring(1)); 
	let sURLVariables = sPageURL.split('&');
	
	for (var sURLVariable of sURLVariables) {
		let sParameterName = sURLVariable.split('=');
		if (sParameterName[0] === name) {
			return  sParameterName[1] === undefined ? true : sParameterName[1];
		}
	}
};

$.EgovIndexApi.prototype._apiExecute = function(contentType, method, url, params, beforeFunc, doneFunc, failFunc) {
	this.jqXhr = 
		$.ajax({
			contentType: contentType,
			type: method,
			url: url,
			data: params,
			dataType: 'json',
			headers: { 'AJAX': true },
			beforeSend: function(xhr) {
				if (beforeFunc !== undefined && beforeFunc !== null) {
					beforeFunc(xhr);
				}
			}
		}).always(function (xhr, status, err) {
			if (status === 'success') {
				let json = xhr;
				if (json.status === 'SUCCESS') {
					doneFunc(json);
				} else {
					failFunc(json);
				}
			}
			else {
				EgovIndexApi._apiResponseException(xhr);
			}
		});
};

$.EgovIndexApi.prototype._apiResponseException = function(xhr) {
	console.log('exception status code: '+ xhr.status)
	switch (xhr.status) {
		case 400:
			toastr.error(xhr.statusText);
			break;
		case 403:
			toastr.error('세션이 종료되어 로그인 페이지로 이동합니다.');
			setTimeout(function() {
				document.location.href = '/backoffice/login.do';
			}, 1000);
			break;
		case 409:
			toastr.error(xhr.responseJSON.message);
			break;
		default:
			if (xhr.responseText === '') {
				toastr.error('시스템에 오류가 발생하였습니다. 관리자에게 문의하세요.');
			} else {
				toastr.error(xhr.responseText);
			}
	}
};

$.EgovIndexApi.prototype.apiExecuteJson = function(method, url, params, beforeFunc, doneFunc, failFunc) {
	if (params === null) {
		params = new Object();
	}
	if (method === 'POST' || method === 'post') {
		params = JSON.stringify(params);
	}
	this._apiExecute('application/json; charset=UTF-8', method, url, params, beforeFunc, doneFunc, failFunc);
};

$.EgovIndexApi.prototype.apiExecuteForm = function(url, params, beforeFunc, doneFunc, failFunc) {
	this._apiExecute('application/x-www-form-urlencoded; charset=UTF-8', 'POST', url, params, beforeFunc, doneFunc, failFunc);
};

$.EgovIndexApi.prototype.s2ab = function(s) {
	var buf = new ArrayBuffer(s.length);
    var view = new Uint8Array(buf);
    for (var i=0; i<s.length; i++) view[i] = s.charCodeAt(i) & 0xFF;
    return buf;
};

const EgovIndexApi = new $.EgovIndexApi();

const EgovCalendar = {
	monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
	weekHeader: 'Wk',
	dateFormat: 'yymmdd',
	autoSize: false,
	changeMonth: true,
	changeYear: true,
	showMonthAfterYear: true,
	buttonImageOnly: false,
	yearRange: '2020:2100'
};

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
		loadonce: loadonce
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
/** JqGrid 메인 그리드 출력 
	- 출력 후 자동 검색 함수 호출
 */
$.EgovJqGridApi.prototype.mainGrid = function(colModel, multiselect, subGrid, searchFunc) {
	this._formatter(colModel);
	this._init('POST', colModel, multiselect, subGrid, false);
	this._jqGridParams['pager'] = $(_MainPagerSelector);
	$(_MainGridSelector).jqGrid(this._jqGridParams);
	$(window).bind('resize', function() {
		// 그리드의 width를 div 에 맞춰서 적용 
		$(_MainGridSelector).setGridWidth($(_MainGridSelector).closest('div.boardlist').width() , true);
	}).trigger('resize');
	if (searchFunc) {
		setTimeout(function() { searchFunc(1) }, _JqGridDelay);
	}
	$('th#'+_MainGridId+'_rn').children('div:first').append('NO');
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
				alert(data.message);
				return false;				
			}
			$('#sp_totcnt').html(data.paginationInfo.totalRecordCount);	
		},
		loadError: function(xhr, status) {
			alert(status);
		},
		onPaging: function(pgButton) {
			let mainGridParams = $(_MainGridSelector).jqGrid('getGridParam');
			let page = mainGridParams['page'];
			let lastpage = mainGridParams['lastpage'];
			switch (pgButton) {
				case 'next':
					page = page < lastpage ? page+1 : page;
					break;
				case 'prev':
					page = page > 1 ? page-1 : page;
					break;
				case 'first':
					page = 1;
					break;
				case 'last':
					page = lastpage;
					break;
				case 'user':
					let now = Number($(_MainPagerSelector+' .ui-pg-input').val());
					page = lastpage >= now && now > 0 ? now : page;
					$(_MainPagerSelector+' .ui-pg-input').val(page);
					break;
				case 'records':
					page = 1;
					break;
				default:
			}
			searchFunc(page);
		},
	};
	if (subFunc) {
		jqGridParams['subGridRowExpanded'] = subFunc;
	}
	$(_MainGridSelector).jqGrid('setGridParam', jqGridParams).trigger('reloadGrid');
};
/** JqGrid 서브 그리드 정의 및 출력 */
$.EgovJqGridApi.prototype.subGrid = function(id, colModel, url, params) {
	this._formatter(colModel);
	this._init('GET', colModel, false, false, true);
	this._jqGridParams['url'] = url;
	this._jqGridParams['postData'] = params;
	this._jqGridParams['jsonReader'] = { root: 'resultlist' };
	$('#'+id).jqGrid(this._jqGridParams);
	$('th#'+id+'_rn').children('div:first').append('NO');
};
/** JqGrid 메인 그리드 상세 팝업 호출 시  */
$.EgovJqGridApi.prototype.mainGridDetail = function(detailFunc) {
	setTimeout(function() {
		$(_MainGridSelector).jqGrid('setGridParam', { 
			onSelectRow: function(rowId, iRow, iCol, e) {
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

const EgovJqGridApi = new $.EgovJqGridApi();