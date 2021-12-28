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

const EgovIndexApi = new $.EgovIndexApi();