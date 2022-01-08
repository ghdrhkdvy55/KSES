/* rsv_blacklist tab (table) */
$('.blacklist.tabs>.tab').on('click', function(){
  var tabIdx = $(this).index();
  var $tabBtn = $('.blacklist.tabs>.tab');
  var $tbody = $('.blacklist.main_table>tbody');
  $tabBtn.removeClass('active');
  $(this).addClass('active');
  $tbody.removeClass('active');
  $tbody.eq(tabIdx).addClass('active');
})

/* popup */
$('[data-popup-open]').bind('click', function () {
  var targeted_popup_class = jQuery(this).attr('data-popup-open');
  $('[data-popup="' + targeted_popup_class + '"]').bPopup();
  e.preventDefault();
});

//공통 팝업
function common_popup(message, alertGubun, hidePopup){
   if (hidePopup != "") {
       $("#btn_ClickId").val(hidePopup);
       $("#"+ hidePopup).bPopup().close();
       $("#a_closePop").hide();
       $("#db_closePop").show();
   }else {
       $("#a_closePop").show();
       $("#db_closePop").hide();
   }
   $("#sp_Message").html(message);
   var colors = alertGubun == "Y" ? "blue" : "red";
   $("#sp_Message").attr("style", "color:"+colors);
   $("#savePage").bPopup();
   
}

//공통 팝업 닫기
function common_modelClose(modelId) {
    $("#"+ modelId).bPopup().close();
}

//공통 팝업 닫기 이전 메세지 창 보여 주기 
function common_modelCloseM(message, modelId){
    $("#btn_ClickId").val('');
    $("#"+ modelId).bPopup().close();
    $("#sp_Message").html(message);
    $("#savePage").bPopup();
}

//페이지 이동 
function view_Page(code, code1, code_value, action_page, frm_nm){
	document.getElementById("mode").value = code;	
	code.value =code_value;	
	frm_nm.action = action_page;
	frm_nm.submit();	
}

//페이지 이동2
function fn_pageMove(formName, pageName) {
	$("form[name=" + formName + "]").attr("action", pageName).submit();
}

//특정 길이 대체 문자
function stringLength (str, strlength, replaceTxt){
	if (str.length < parseInt(strlength)){
		for (var i =0; i < (parseInt(strlength) - str.length); i++ ){
			str = replaceTxt + str;
		}
	}else {
		str = str;
	}
	return str;
}

// 공통 체크 구문
function any_empt_line_span(close_modal, frm_nm, alert_message, spanTxt, bPopup){
     $("#"+ close_modal).bPopup().close();
     $("#btn_ClickId").val(close_modal);
     $("#a_closePop").hide();
     $("#db_closePop").show();
     
	 var form_nm = eval("document.getElementById('"+frm_nm+"')");
	 $("#sp_errorMessage").html("");
	 if (form_nm.value.length < 1){
		  $("#sp_Message").html(alert_message);
		  $("#sp_Message").attr("style", "color:red");
		  $("#"+ frm_nm).attr("style", "border-color:red");
		  $("#"+bPopup).bPopup()
		  return false;
	 }else{
        return true;
	 }
}

function any_empt_line_span_noPop(frm_nm, alert_message, spanTxt){        
   	 var form_nm = eval("document.getElementById('"+frm_nm+"')");
   	 $("#sp_errorMessage").html("");
   	 if (form_nm.value.length < 1){
   		  $("#sp_Message").html(alert_message);
   		  $("#sp_Message").attr("style", "color:red");
   		  $("#"+ frm_nm).attr("style", "border-color:red");
   		  $("#savePage").bPopup()
   		  return false;
   	 }else{
           return true;
   	 }
}

function fn_Ajax(url, _type, param, async, done_callback, fail_callback){
    param = (_type == "GET") ? param :JSON.stringify(param);
	var jxFax =  $.ajax({
		        type :_type,
		        url : url,
		        async : async,
		        beforeSend:function(jxFax, settings){
	        	   jxFax.setRequestHeader('AJAX', true);
	        	   //$('.loadingDiv').show();
	            }, 
		        complete : function(jqXHR, textStatus) {
		        },
		        contentType : "application/json; charset=utf-8",
		        data : param
		    }).done(done_callback).fail(fail_callback);
	return jxFax;
}

function uniAjax(url, param, async, done_callback, fail_callback){
	var jxFax =  $.ajax({
		        type : 'POST',
		        url : url,
		        async : async,
		        beforeSend:function(jxFax, settings){
	        	   jxFax.setRequestHeader('AJAX', true);
	        	   //$('.loadingDiv').show();
	            }, 
		        complete : function(jqXHR, textStatus) {
		        },
		        contentType : "application/json; charset=utf-8",
		        data : JSON.stringify(param)
		    }).done(done_callback).fail(fail_callback);
	return jxFax;
}

function uniAjaxSerial(url, param, async, done_callback, fail_callback){
	var jxFax =  $.ajax({
		        type : 'GET',
		        url : url,
		        async : async,
		        beforeSend : function(jqXHR, settings) {
			       jqXHR.setRequestHeader('AJAX', true);
			       //$('.loadingDiv').show();
		        }, 
		        complete : function(jqXHR, textStatus) {
		        },
		        contentType : "application/json; charset=utf-8",
		        data : param,
		    }).done(done_callback).fail(fail_callback);
    return jxFax;
}

//토글 버튼 스크립트
function toggleValue(obj){
	 $(obj).is(":checked") ? $(obj).val("Y") : $(obj).val("N");
}

function toggleClick(obj, val){
     val = (val == undefined)  ? "N" : val;
     $("#"+obj).val(val);
     console.log("obj:" + obj + val);
     if (val == "Y" && !$("#"+obj).is(":checked")){
        $("#"+obj).trigger("click");
     }else if (val != "Y" && $("#"+obj).is(":checked")){
        $("#"+obj).trigger("click");
     }
		 
}

//토글 디폴트 
function toggleDefault(obj){
     if ($("#"+obj).is(":checked"))
		 $("#"+obj).trigger("click");
}

function fn_emptyReplace(ckValue, replaceValue){
	return  (ckValue == "" || ckValue == undefined ) ? replaceValue : ckValue;
}

// 삭제 버트 
function fn_uniDelAction(_url, _type, _data, async, _action_url){
        _data = (_type == "GET") ? _data :JSON.stringify(_data);
        $.ajax({
			url: _url,
			type : _type,
			async : async,
			beforeSend:function(jxFax, settings){
	        	jxFax.setRequestHeader('AJAX', true);
	        },
	        data : _data,
			contentType : "application/json; charset=utf-8",
			success :function (data, textStatus, jqXHR){
				 if (data.status == "SUCCESS"){
					 // 추후 다른 framework 으로 변경 예정
					 common_modelCloseM("정상적으로 삭제 되었습니다","confirmPage");
					 if (_action_url != ""){
					    var call_script = eval("window."+_action_url+"();"); 
					 }
				 }else if (data.status == "LOGIN FAIL"){
				    common_modelCloseM(result.meesage, "confirmPage");
		   			location.href="/backoffice/login.do";
				 }else {
				     common_modelCloseM(data.message, "confirmPage");
				 }
			},
			error: function (jqXHR, textStatus, errorThrown){
			    common_modelCloseM(textStatus + ":" + errorThrown, "confirmPage");
			}
		});
}

//jqGrid 체크 박스 체크된 값 알아오기 
function getEquipArray(id, array){
    var ids = $("#"+id).jqGrid('getDataIDs');
    for (var i = 0; i < ids.length; i++) { //row id수만큼 실행          
	    if($("input:checkbox[id='jqg_"+id+"_"+ids[i]+"']").is(":checked")){ //checkbox checked 여부 판단
		    var rowdata = $("#grid_id").getRowData(ids[i]); // 해당 id의 row 데이터를 가져옴
		    array.push(ids[i]);
  
	    }
	
	}
}

// 이미지 업로드
function uniAjaxMutipart(url, formData, done_callback, fail_callback){
	var jxFax =  $.ajax({
				        type : 'POST',
				        url : url,
	                    beforeSend : function(jqXHR, settings) {
		                  //이미지 업로드 보여주기
		                  jqXHR.setRequestHeader('AJAX', true);
			            },
				        processData: false,
				        contentType : false,
			            cache: false,
			            timeout: 600000,
	                    data : formData,
	                    type: 'POST',
	                    complete : function(jqXHR, textStatus) {
		                       
			            },
			    }).done(done_callback).fail(fail_callback);
    return jxFax;
}

//패스워드 설정 
function chkPwd(str){
	 var reg_pwd = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
	 if(!reg_pwd.test(str)){
	  return false;
	 }
	 return true;
}

//숫자입력 유효성검사 
function onlyNum(el) {
	$(el).val($(el).val().replace(/[^0-9]/g,""));
}

//빈값 체우기
function fnLPAD(val, set, cnt) {
    if (!set || !cnt || val.length >= cnt) {
        return val;
    }
    var max = (cnt - val.length) / set.length;
    for (var i = 0; i < max; i++) {
        val = set + val;
    }
    return val;
}

//공백 제거
function trim(str){
	return str.replace(/^\s\s*/, '').replace(/\s\s$/,'');
}

//토글 버튼 스크립트
function toggleValue(obj){
	 $(obj).is(":checked") ? $(obj).val("Y") : $(obj).val("N");
}

function toggleClick(obj, val){
     $("#"+obj).val(val); 
     console.log("toggleClick:" + $("#"+obj).val());
     
     if (val == "Y" && !$("#"+obj).is(":checked"))
		 $("#"+obj).trigger("click");
}

//토글 디폴트 
function toggleDefault(obj){
     if ($("#"+obj).is(":checked"))
		 $("#"+obj).trigger("click");
}

//form reset 시키기 
function resetForm(f){
	$el = $(f);
	$('input:text', $el).val('');
	$('input:hidden', $el).val('');
	$('textarea', $el).val('');
	$('select', $el).each(function(){
		if($(this).find('option.default').size() > 0){
			$(this).find('option.default').attr('selected','true');			
		}else{
			$(this).find('option:first').attr('selected','true');
		}
	});
	$('input:checkbox', $el).attr("checked", false);
}

//이메일 형식
function verifyEmail(_field, mng_user_add){
    var emailVal = $("#"+_field).val(); 
	var reg_email = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	if (!reg_email.test(emailVal)) { 
		common_popup("입력한 이메일이 형식에 맞지 않습니다.", "N", mng_user_add);
		return false; 
	} else { 
		return true; 
	}
}

//휴대폰 번호 유효성 검사
function validPhNum(phNum) {
	var reg = /^\d{3}\d{3,4}\d{4}$/;
	if(!reg.test(phNum)) {
		return false;
	} else {
		return true;
	}
}

//공통값 return 
function uniAjaxReturn(url, _type, _async,  param, _rtnGubun){
    var returnVal = "";
    data = (_type == "GET") ? param :JSON.stringify(param);
    
	$.ajax({
		        type : _type,
		        url : url,
		        async: _async,
		        beforeSend:function(jxFax, settings){
	        	   jxFax.setRequestHeader('AJAX', true);
	        	   //$('.loadingDiv').show();
	            }, 
		        complete : function(jqXHR, textStatus) {
		        },
		        contentType : "application/json; charset=utf-8",
		        data : data
		    }).done(function(result){
		           if (result.status == "LOGIN FAIL"){
			    	   common_popup(result.meesage, "N", "");
					   location.href="/web/Login";
				   }else if (result.status == "SUCCESS"){
				        if (_rtnGubun == "lst")
			                returnVal=  result.resultlist;
			            else 
			                returnVal=  result.result;
			            
				   }else {
				       //alert("여기 확인");
				       common_popup(result.meesage, "N", "");
				   }
		       }
		    ).fail(function(request){
		          common_popup("Error:" +request.status, "N", "");
	});
	return returnVal;
} 

//빈값 체크
function fn_NVL(reqValue) {
	return (reqValue == undefined || reqValue == "") ? "" : reqValue;
}

//금일값 구하기
function today_get() {
	var now = new Date();
    var today_day = fnLPAD(String(now.getDate()), "0", 2); //일자를 구함
    var today_month = fnLPAD(String((now.getMonth() + 1)), "0", 2); // 월(month)을 구함    
    var today_year = String(now.getFullYear()); //년(year)을 구함
    var today = today_year + today_month + today_day;
    
    return today;
}

//팝업열기
function bPopupOpen(el) {
	$("#" + el).bPopup();
}

//팝업닫기
function bPopupClose(el) {
	$("#" + el).bPopup().close();
}

/* FRONT RESERVATION */
/**
 * 예약일 포팻
 * 
 * @param el
 * @returns
 */
function fn_resvDateFormat(el) {
	if(el.length == 8) {
		el = el.substring(0,4) + "-" + el.substring(4,6) + "-" + el.substring(6,8);
	}
	return el;
}

/**
 * 예약번호 포맷팅
 * 
 * @param el
 * @returns
 */
function fn_resvSeqFormat(el) {
    return el.toString().replace(/\B(?=(\d{4})+(?!\d))/g, "-");
}

/**
 * 금액 포맷팅
 * 
 * @param el
 * @returns
 */
function fn_cashFormat(el) {
    return el.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

/**
 * 스크롤 이동
 * 
 * @param el -> 이동할 태그
 * @returns
 */
function fn_scrollMove(el) {
	var offset = $(el).offset(); //선택한 태그의 위치를 반환
	$('html').animate({scrollTop : offset.top - 100}, 800);
}

//예약페이지 만료시간 체크
function resvUsingTimeCheck(time) {
	setInterval(function(){
		var date = new Date();
		var today = date.format("yyyyMMddHHmm");
		
		if(time < today){
/*			alert("예약페이지 이용시간을 초과하였습니다.");
			location.href = "/front/main.do";*/
		}
	},5000);
}

/**
 * 동일자 다중예약 방지
 * @param -> userDvsn(회원구분) userId(아이디) userPhone(전화번호) resvDate(예약하려는일자)
 * 
 * @returns
 */
function fn_resvDuplicateCheck(params) {
	var url = "/front/resvInfoDuplicateCheck.do";
	var isResvDuplicate = true;
	
	fn_Ajax
	(
	    url,
	    "POST",
	    params,
	    false,
	    function(result) {
	    	if (result.status == "SUCCESS") {
	    		if(result.resvCount > 0) {
	    			isResvDuplicate = true;
	    		} else {
	    			isResvDuplicate = false;
	    		}
	    	} else if(result.status == "LOGIN FAIL") {
	    		fn_openPopup("로그인 정보가 올바르지 않습니다.", "red", "ERROR", "확인", "/front/main.do");
	    	} else {
	    		fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");
	    	}
	    },
	    function(request) {
	    	fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
	    }    		
	);
	return isResvDuplicate;
}

/**
 * 사용자 예약정보 조회
 * 
 * @param -> resvSeq(예약번호)
 * @returns
 */
function fn_getResvInfo (resvSeq) {
	var url = "/front/getResvInfo.do";
	var isSuccess = false;
	var resvResult = {};
	
	var params = {
	    "resvSeq" : resvSeq
	}
	
	fn_Ajax
	(
	    url,
	    "GET",
		params,
		false,
		function(result) {
	    	if(result.status == "SUCCESS") {
		    	if(result.resvInfo != null) {
		    		resvResult = result.resvInfo;
					isSuccess = true;
		    	} else {
		    		fn_openPopup("해당 예약정보가 존재하지 않습니다.", "red", "ERROR", "확인", "");
		    	}
	    	} else if(result.status == "LOGIN FAIL") {
	    		fn_openPopup("로그인 정보가 올바르지 않습니다.", "red", "ERROR", "확인", "/front/main.do");
	    	} else {
	    		fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");
	    	}
		},
		function(request) {
			fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
		}    		
	);
	
	resvResult.isSuccess = isSuccess;  
	return resvResult;
}

/**
 * 사용자 예약 취소 공통
 * 
 * @param resvInfo
 * @param payResult
 * @returns
 */
function fn_resvCancel(resvInfo, payResult, callback) {
	var url = "/front/resvInfoCancel.do";
	var isSuccess = false;
	
	resvInfo.resv_cancel_id = resvInfo.user_id;
	resvInfo.resv_cancel_cd = "RESV_CANCEL_CD_2";
	
	fn_Ajax
	(
	    url,
	    "POST",
	    resvInfo,
		false,
		function(result) {
			if (result.status == "SUCCESS") {
				payResult != null ?
					fn_openPopup(
						"예약이 정상적으로 취소되었습니다." + "<br>" +
						"입금금액 : " + fn_cashFormat(payResult.occurVal) + "<br>" +
						"잔액 : " + fn_cashFormat(payResult.balan), 
						"blue", "SUCCESS", "확인", ""
					) :
					fn_openPopup("예약이 정상적으로 취소되었습니다.", "blue", "SUCCESS", "확인", "");
				isSuccess = true;
			} else if (result.status == "LOGIN FAIL") {
				fn_openPopup("로그인 정보가 올바르지 않습니다.", "blue", "SUCCESS", "확인", "/front/main.do");
			} else {
				fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");
			}
		},
		function(request) {
			fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
		}
	);	
	
	return isSuccess;
}

/**
 * 결제 취소 공통
 * 
 * @param params
 * @returns
 */
function fn_payment(resvInfo) {
	var url = "/backoffice/rsv/speedCheck.do";
	var isSuccess = false;
	
	var params = {
		"gubun" : "dep",
		"sendInfo" : {
			"resvSeq" : resvInfo.resv_seq,
			"Card_Pw" : $("#Card_Pw").val(),
			"System_Type" : "E"
		}
	}
	
	fn_Ajax
	(
	    url,
	    "POST",
		params,
		false,
		function(result) {
	    	if(result.regist != null) {
				if(result.regist.Error_Msg == "SUCCESS") {
					isSuccess = fn_resvCancel(resvInfo, result.regist.result);
					console.log(isSuccess);
				} else {
					fn_openPopup(result.regist.Error_Msg, "red", "ERROR", "확인", "javascript:location.reload();");
				}
	    	} else if (result.status == "LOGIN FAIL") {
	    		fn_openPopup("로그인 정보가 올바르지 않습니다.", "red", "ERROR", "확인", "/front/main.do");
	    	} else {
	    		fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");
	    	}
		},
		function(request) {
			fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
		}    		
	);	
	
	return isSuccess;
}


/**
 * 예약 유효성 검사
 * 
 * @param params
 * @returns
 */
function fn_resvVaildCheck(params) {
	var url = "/front/resvValidCheck.do";
	var validResult;
	
	fn_Ajax
	(
	    url,
	    "POST",
		params,
		false,
		function(result) {
			if (result.status == "SUCCESS") {
				if(result.validResult.resultCode != "SUCCESS") {
					fn_openPopup(result.validResult.resultMessage, "red", "ERROR", "확인", "");
				} else {
					validResult = result.validResult;
				}
			} else if (result.status == "LOGIN FAIL"){
				fn_openPopup("로그인 정보가 올바르지 않습니다.", "red", "ERROR", "확인", "/front/login.do");
			}
		},
		function(request) {
			fn_openPopup("처리중 오류가 발생하였습니다.", "red", "ERROR", "확인", "");	       						
		}    		
	);	
	
	return validResult;
}

function fn_moveQrPage(resvSeq) {
	location.href = "/front/qrEnter.do?resvSeq=" + resvSeq + "&accessType=WEB";
}

Date.prototype.format = function (f) {
    if (!this.valueOf()) return " ";
    var weekKorName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var weekKorShortName = ["일", "월", "화", "수", "목", "금", "토"];
    var weekEngName = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    var weekEngShortName = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    var d = this;

    return f.replace(/(yyyy|yy|MM|dd|KS|KL|ES|EL|HH|hh|mm|ss|a\/p)/gi, function ($1) {
        switch ($1) {
            case "yyyy": return String(d.getFullYear()).replace(' ',''); // 년 (4자리)
            case "yy": return (d.getFullYear() % 1000).zf(2); // 년 (2자리)
            case "MM": return (d.getMonth() + 1).zf(2); // 월 (2자리)
            case "dd": return d.getDate().zf(2); // 일 (2자리)
            case "KS": return weekKorShortName[d.getDay()]; // 요일 (짧은 한글)
            case "KL": return weekKorName[d.getDay()]; // 요일 (긴 한글)
            case "ES": return weekEngShortName[d.getDay()]; // 요일 (짧은 영어)
            case "EL": return weekEngName[d.getDay()]; // 요일 (긴 영어)
            case "HH": return d.getHours().zf(2); // 시간 (24시간 기준, 2자리)
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2); // 시간 (12시간 기준, 2자리)
            case "mm": return d.getMinutes().zf(2); // 분 (2자리)
            case "ss": return d.getSeconds().zf(2); // 초 (2자리)
            case "a/p": return d.getHours() < 12 ? "오전" : "오후"; // 오전/오후 구분
            default: return $1;
        }
    });
};

String.prototype.string = function (len) { var s = '', i = 0; while (i++ < len) { s += this; } return s; };
String.prototype.zf = function (len) { return "0".string(len - this.length) + this; };
Number.prototype.zf = function (len) { return this.toString().zf(len); };