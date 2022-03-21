$.EgovIndexApi = function() {
	console.log('EgovIndexApi');
};
/************************************************************************************************
 * Private 공통 함수
 * - 외부에서 호출하지 말것
 ************************************************************************************************/
$.EgovIndexApi.prototype._apiExecute = function(contentType, method, url, params, beforeFunc, doneFunc, failFunc) {
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
			console.log('exception status code: '+ xhr.status);
			// if (xhr.responseText === '') {
			toastr.error('시스템에 오류가 발생하였습니다. 관리자에게 문의하세요.');
		// } else {
		// 	toastr.error(xhr.responseText);
		// }
	}
};
/************************************************************************************************
 * public 공통 함수
 ************************************************************************************************/
/**
 * Json 방식 Ajax 통신
 */
$.EgovIndexApi.prototype.apiExecuteJson = function(method, url, params, beforeFunc, doneFunc, failFunc) {
	if (params === null) {
		params = new Object();
	}
	if (method === 'POST' || method === 'post') {
		params = JSON.stringify(params);
	}
	this._apiExecute('application/json; charset=UTF-8', method, url, params, beforeFunc, doneFunc, failFunc);
};
/**
 * Form 방식 Ajax 통신
 * - POST 전용
 */
$.EgovIndexApi.prototype.apiExecuteForm = function(url, params, beforeFunc, doneFunc, failFunc) {
	this._apiExecute('application/x-www-form-urlencoded; charset=UTF-8', 'POST', url, params, beforeFunc, doneFunc, failFunc);
};
/**
 * Multipart 방식 Ajax 통신
 */
$.EgovIndexApi.prototype.apiExcuteMultipart = function(url, formData, beforeFunc, doneFunc, failFunc) {
	$.ajax({
		enctype: 'multipart/form-data',
		contentType: false,
		processData: false,
		type: 'POST',
		url: url,
		data: formData,
		cache: false,
		timeout: 600000,
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
/**
 * CamelCase 문자열
 */
$.EgovIndexApi.prototype.camelToUnderscore = function(key) {
	let result = key.replace(/([A-Z])/g, " $1" );
	return result.split(' ').join('_').toLowerCase();
};
/**
 * 파라미터 값 얻기
 */
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
/**
 * 엑셀 변환 시 필요
 */
$.EgovIndexApi.prototype.s2ab = function(s) {
	var buf = new ArrayBuffer(s.length);
    var view = new Uint8Array(buf);
    for (var i=0; i<s.length; i++) view[i] = s.charCodeAt(i) & 0xFF;
    return buf;
};
/**
 * 숫자만 입력 가능
 */
$.EgovIndexApi.prototype.numberOnly = function(el) {
	let $el = (el) ? $(el) : $('input:text[numberonly]');
	$el.on('focus', function () {
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
/**
 * 전화번호 형식으로 입력 가능
 */
$.EgovIndexApi.prototype.phoneOnly = function() {
	$('input:text[phoneonly]').attr({
		maxlength: '13'
	}).on('focus', function () {
		let x = $(this).val();
		$(this).val(x);
	}).on('focusout', function() {
		let x = $(this).val();
		if (x && x.length > 0) {
			if ($.isNumeric(x)) {
				x = x.replace(/[^0-9][-]/g, "");
			}
			$(this).val(x);
		}
	}).on('keyup', function() {
		$(this).val($(this).val().replace(/[^0-9][-]/g, ""));
	});
};
/**
 * 암호 형식 제한
 */
$.EgovIndexApi.prototype.vaildPassword = function(str) {
	let regExp = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
	if (!regExp.test(str)) {
		return false;
	}
	return true;
};
/**
 * Email 형식으로 제한
 */
$.EgovIndexApi.prototype.validEmail = function(str) {
	var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/;
	if (!regExp.test(str)) {
		return false;
	}
	return true;
};

$.EgovIndexApi.prototype.partColorList = [
	"a_sec,#ffbc26",
	"b_sec,#4abcff",
	"c_sec,#ff6e42",
	"d_sec,#b665ff",
	"e_sec,#ff65e5",
	"f_sec,#6e65ff",
	"g_sec,#4b8bff",
	"h_sec,#27c7a9",
	"i_sec,#1c4acf",
	"j_sec,#ff186d",
	"k_sec,#426021",
	"gr_sec,#206618",
	"n_sec,#80D242",
	"p_sec,#EC4A4F",
	"s_sec,#11195D"
];

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

/**
 * 팝업 버튼 공통 클래스
 * - okText: 기본 저장 버튼 라벨 변경 시
 * - clickFunc: 저장 버튼 클릭 시 호출 함수
 * - noText: 기본 취소 버튼 라벨 변경 시
 */
class PopupRightButton extends HTMLElement {
	constructor() {
		super();
		let html = [];
		html.push('<div class="right_box">');
		
		let okText = this.getAttribute('okText') === null ? '저장' : this.getAttribute('okText');
		if (this.getAttribute('clickFunc') === null) {
			html.push('<button type="button" class="blueBtn">'+ okText +'</button>');
		} else {
			html.push('<button type="button" onclick="'+ this.getAttribute('clickFunc') +'" class="blueBtn">'+ okText +'</button>');
		}
		let noText = this.getAttribute('noText') === null ? '취소' : this.getAttribute('noText');
		html.push('<button type="button" class="grayBtn b-close">'+ noText +'</button>');
		html.push('</div>');
		html.push('<div class="clear"></div>');
		$(this).html(html.join(''));		
	}
}