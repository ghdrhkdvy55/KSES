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
		case 200:
			break;
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

$.EgovIndexApi.prototype.numberOnly = function() {
	$('input:text[numberOnly]').on('focus', function () {
		let x = $(this).val();
		$(this).val(x);
	}).on('focusout', function() {
		let x = $(this).val();
		if (x && x.length > 0) {
			if ($.isNumeric(x)) {
				x = x.replace(/[^0-9]/g, "");
			}
			$(this).val(x);
		}
	}).on('keyup', function() {
		$(this).val($(this).val().replace(/[^0-9]/g, ""));
	});
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