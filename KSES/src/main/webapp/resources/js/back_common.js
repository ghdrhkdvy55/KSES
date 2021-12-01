/*이미지 썸네일*/
$(document).ready(function() {
openNav();
var xOffset = 10;
var yOffset = 30;



$(document).on("mouseover", ".jqgrow >td >img", function(e) { //마우스 오버시

$("body").append("<p id='preview'><img src='" + $(this).attr("src") + "' width='300px' /></p>"); //보여줄 이미지를 선언
$("#preview")
.css("top", (e.pageY - xOffset) + "px")
.css("left", (e.pageX + yOffset) + "px")
.fadeIn("fast"); //미리보기 화면 설정 셋팅
});



$(document).on("mousemove", ".jqgrow >td >img", function(e) { //마우스 이동시
$("#preview")
.css("top", (e.pageY - xOffset) + "px")
.css("left", (e.pageX + yOffset) + "px");
});



$(document).on("mouseout", ".jqgrow >td >img", function() { //마우스 아웃시
$("#preview").remove();
});



});



/* menu */
function toggleNav() {
if (document.getElementById("mySidenav").style.display == "none") {
openNav();
} else {
closeNav();
}
}
function openNav() {
document.getElementById("mySidenav").style.display = "block";
document.getElementById("mySidenav").style.width = "200px";
document.getElementById("contents").style.marginLeft = "200px";
document.getElementById("header").style.marginLeft = "0";
}
function closeNav() {
document.getElementById("mySidenav").style.display = "none";
document.getElementById("mySidenav").style.width = "0";
document.getElementById("contents").style.marginLeft= "0";
document.getElementById("header").style.marginLeft= "-200px";
}
/* sub menu */
var acc = document.getElementsByClassName("sub_menu");
var i;



for (i = 0; i < acc.length; i++) {
acc[i].addEventListener("click", function() {
this.classList.toggle("toggle_on");
var panel = this.nextElementSibling;
if (panel.style.display === "block") {
panel.style.display = "none";



} else {
panel.style.display = "block";
}
});
}
/* popup */
$('[data-popup-open]').bind('click', function () {
  var targeted_popup_class = jQuery(this).attr('data-popup-open');
  $('[data-popup="' + targeted_popup_class + '"]').bPopup();
  e.preventDefault();
  });

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

// 맨 마지막 문자 얻어 오기 
function fn_Endstring(_field){
  var val =  $("#"+_field).val();
  return val.slice(val.length -1)
}

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
   $("#savePage #sp_Message").html(message);
   var colors = alertGubun == "Y" ? "blue" : "red";
   $("#savePage #sp_Message").attr("style", "color:"+colors);
   $("#savePage").bPopup();
   
}
//공통 팝업 Action
function common_reloadPopup(message, alertGubun){

   
   $("#sp_Message").html(message);
   var colors = alertGubun == "Y" ? "blue" : "red";
   $("#sp_Message").attr("style", "color:"+colors);
   $("#reloadPage").bPopup();
   
}
//공통 팝업 닫기
function common_modelClose(modelId){
    $("#"+ modelId).bPopup().close();
    
}
//공통 팝업 닫기 이전 메세지 창 보여 주기 
function common_modelCloseM(message, modelId){
    $("#btn_ClickId").val('');
    $("#"+ modelId).bPopup().close();
    $("#savePage #sp_Message").html(message);
    $("#savePage").bPopup();
}
//팝업 닫기 후 신규 팝업 창 보여 주기 
function common_modelOpen(_closeModel, _openModel){
   $("#"+_closeModel).bPopup().close();  
   $("#"+_openModel).bPopup();   
}
//페이지 이동 
function view_Page(code, code1, code_value, action_page, frm_nm){
	document.getElementById("mode").value = code;	
	code.value =code_value;	
	frm_nm.action = action_page;
	frm_nm.submit();	
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
		  $("#savePage #sp_Message").html(alert_message);
		  $("#savePage #sp_Message").attr("style", "color:red");
		  $("#"+ frm_nm).attr("style", "border-color:red");
		  $("#"+bPopup).bPopup()
		  return false;
	 } else{
        return true;
	 }
}
function any_empt_line_span_noPop(frm_nm, alert_message){        
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
//전화번호 정규식
function fn_autoHyphen (obj){
   
   return obj.value.replace(/[^0-9]/, '').replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, `$1-$2-$3`);
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
				       
				       common_popup(result.meesage, "N", "");
				   }
		       }
		    ).fail(function(request){
		          common_popup("Error:" +request.status, "N", "");
	});
	return returnVal;
} 
//빈값 체크
function fn_NVL (reqValue){
	return (reqValue == undefined || reqValue == "") ? "" : reqValue;
}

// 값 비교 후 경고 문구 보내기
function fnIntervalCheck(stratVal, endVal, alertMessge, _modelPop){
    if (parseInt(stratVal) > parseInt(endVal)){
		common_popup(alertMessge, "N",_modelPop);
		return false;
	}
	return true;
}
// 사용층 checkbox 생성 
function fnCreatCheckbox(_returnObject, _startVal, _endVal, _checkVal, _checkboxNm, _checkTxt){
	var checked = "";
	$("#"+_returnObject).empty();
	var count = 0;
	var object_height = 1;
	for (var i = parseInt(_startVal); i <= parseInt(_endVal); i ++ ){
		checked = _checkVal.includes(i) ? "checked" : "";
		count += 1;
		console.log(count%5);
		if (count%6 === 0){
		   object_height += 1;
		   $("#"+_returnObject).append("<br/>").css('height',(object_height * 60));
		}
		$("#"+_returnObject).append("&nbsp;<input type='checkbox' name='"+_checkboxNm+"'  value='"+i+"' "+checked+">" + i+ _checkTxt);
	}
}
//체크 박스 체크 여부
function ckeckboxValue(message, checkboxNm, _modelPop){
	var checkboxvalue = "";
	var check_length = $("input:checkbox[name="+checkboxNm+"]:checked").length;
	if (check_length <1){
		common_popup(message, "N",_modelPop);
		return false;
	}else {
		$("input:checkbox[name="+checkboxNm+"]:checked").each(function(){
			checkboxvalue = checkboxvalue+","+ $(this).val();
		});	
	}
	return checkboxvalue.substring(1);
}
//숫자만 입력 
function only_num() {
    if (((event.keyCode < 48) || (event.keyCode > 57)) && (event.keyCode != 190)) event.returnValue = false;
}
//지난 일자는 등록 하지 못하게 하기 
function yesterDayConfirm(res_day, alert_message){
	var day = new Date();
    var dateNow = fnLPAD(String(day.getDate()), "0", 2); //일자를 구함
    var monthNow = fnLPAD(String((day.getMonth() + 1)), "0", 2); // 월(month)을 구함    
    var yearNow = String(day.getFullYear()); //년(year)을 구함
    var today = yearNow + monthNow + dateNow;
    
    if (parseInt(res_day) < today){
    	alert(alert_message);
    	return false;
    }else {
    	return true;
    }
}
//체크 박스 전체 선택
function fn_CheckboxAllChange(ck_nm, boolean){
   $("input[name="+ck_nm+"]").prop("checked", boolean);
}
function fn_CheckboxChoice(ck_nm, choiceValue){
   $("input[name="+ck_nm+"]").prop("checked", false);
   if (choiceValue != "" && choiceValue != undefined){
      choiceValue.split(",").forEach(function(item) {
          $("#"+item).prop("checked", true);
          console.log(item);
      });
   }
}
// html #요소 삭제 
function fn_EmptyField(_Field){
   $("#"+_Field).empty();
}
//combobox 자동 생성 
// 콤보 박스 리스트
// _spField #span 에다 넣기 
// _Field
function fn_comboList(_spField, _Field, _url, _type, _async, _params, _onChangeAction, _width, _checkVal){
		    // params로 보내기 
		    data = (_type == "GET") ? param :JSON.stringify(param);
		    
		    if (($("#"+_spField) != undefined && $("#"+_Field) == undefined) ||
		        ($("#"+_spField) == "" && $("#"+_Field) == undefined)   ){
		        var onChangeTxt =  _onChangeAction != "" ? "onChange='" + _onChangeAction+ "'" :  "";
		    	$("#"+_spField).html("<select id='"+ _Field + "' name='"+ _Field + "'" + onChangeTxt+" style='width:" + _width + "'></select>");
		    }else {
		         $("#"+_Field).prop("style",_width);
		         //동적 이벤트 정리 하기 
		    }
		    fn_Ajax(_url, 
		                _type, 
		                _async,
		                _params,
		                function(result) {
					       if (result.status == "LOGIN FAIL"){
					    	   location.href="/backoffice/login.do";
						   }else if (result.status == "SUCCESS"){
							   //총 게시물 정리 하기
							    if (result.resultlist.length > 0){
							        var obj  = result.resultlist;
								    $("#"+_Field).empty();
								    $("#"+_Field).append("<option value=''>선택</option>");
								    for (var i in obj) {
								        var array = Object.values(obj[i])
								        var ckString = (array[0] === _checkVal) ? "selected" : "";
								        $("#"+_Field).append("<option value='"+ array[0]+"' "+ckString+">"+array[1]+"</option>");
								    }
							    }else {
							      //값이 없을때 처리 
							      $("#"+_Field).empty();
							      return "0";
							    }
							    
						   }
					    },
					    function(request){
						    common_modelCloseM("Error:" +request.status, "confirmPage");      						
					    }    		
			 ); 
		       
}
// json 객체 combobox 만들기

function fn_comboListJson(_Field, _result, _onChangeAction, _width, _checkVal){
    // params로 보내기 
    if (_width != ""){
       $("#"+_Field).width(_width);
    }  
    if (_onChangeAction != ""){
       $("#"+_Field).on('change', function(){
          var call_script = eval("window."+_onChangeAction+"();"); 
       });
    }
    //동적 이벤트 정리 하기 
    if (_result.length > 0){
	        var obj  = _result;
		    $("#"+_Field).empty();
		    $("#"+_Field).append("<option value=''>선택</option>");
		    for (var i in obj) {
		        var array = Object.values(obj[i])
		        var ckString = (array[0] === _checkVal) ? "selected" : "";
		        $("#"+_Field).append("<option value='"+ array[0]+"' "+ckString+">"+array[1]+"</option>");
		    }
	 }else {
	      //값이 없을때 처리 
	      $("#"+_Field).empty();
	 }       
}
// 신규 동적 체크 박스 생성 
function fn_checkboxListJson(_returnObject, _result, _checkVal, _checkboxNm){
	var checked = "";
	$("#"+_returnObject).empty();
	var count = 0;
	var object_height = 1;
	console.log(JSON.stringify(_result));
	
	
	for (var i in _result) {
	    var array = Object.values(_result[i])
		checked = _checkVal.includes(array[0]) ? "checked" : "";
		count += 1;
		if (count%6 === 0){
		   object_height += 1;
		   $("#"+_returnObject).append("<br/>").css('height',(object_height * 60));
		}
		$("#"+_returnObject).append("&nbsp;<input type='checkbox' name='"+_checkboxNm+"'  value='"+array[0]+"' "+checked+">" + array[1]);
	}
}
// 공백값 치환
function fn_NVL(reqValue){
    return (reqValue == undefined || reqValue == "") ? "" : reqValue;
}
// rgb -> hex 로 변환
function rgb2hex(rgb) {
     if (  rgb.search("rgb") == -1 ) {
          return rgb;
     } else {
          rgb = rgb.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*(\d+))?\)$/);
          function hex(x) {
               return ("0" + parseInt(x).toString(16)).slice(-2);
          }
          return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]); 
     }
}

//css select box 
function fn_cssSelect(_Field, _checkVal){
    $("#"+_Field).empty();
    var obj = [ "a_sec,#ffbc26",
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
				"s_sec,#11195D"];    
	$("#"+_Field).append("<option value=''>선택</option>");
    for (var i in obj) {
        var array = obj[i].split(",");
	    var ckString = (array[0] === _checkVal) ? "selected" : "";
        $("#"+_Field).append("<option value='"+array[0]+"' "+ckString+" style='background:"+array[1]+"'>>"+array[1]+"</option>");
    }
    return;
}
//css option 색상 select 색상으로 
function fn_SelectColor(id){
    var color = $("#"+id+" option:selected").text();
    $("#"+id).css("backgroundColor",color);
}
//두 배열 중복값 제거
function findUniqElem(arr1, arr2) {
  return arr1.concat(arr2)
    	 .filter(item => !arr1.includes(item) || !arr2.includes(item));
}

//페이징 스크립트;
function ajaxPaging(currentPageNo, firstPageNo, recordCountPerPage, firstPageNoOnPageList, lastPageNoOnPageList, totalPageCount, pageSize, pageScript){
    var pageHtml = "";
    pageHtml += "";
	 if (currentPageNo == firstPageNo ){
      pageHtml += "<a href='#' >&laquo;</a>";
	 }else {
      pageHtml += "<a href='#' onclick='"+pageScript+"("+ firstPageNo +")';return false; '>&laquo;</a>";
	 }
	 if (parseInt(currentPageNo) > parseInt(firstPageNo)){
      pageHtml += "<a href='#' onclick='"+pageScript+"("+ parseInt(parseInt(currentPageNo) -1)+");return false;'>&lt;</a>"
	 }else {
      pageHtml += "<a href='#' >&lt;</a>"
	 }
    for(var  i = firstPageNoOnPageList; i<= lastPageNoOnPageList; i++){
		 if (i == currentPageNo){
            pageHtml += "<a class=active>"+i+"</a>";
		 }else {
            pageHtml += "<a href='#' onclick='"+pageScript+"("+i+");return false; '>"+i+"</a>";
		 }
    }

	 if (parseInt(totalPageCount) > parseInt(pageSize) ){
        pageHtml += "<a href='#' onclick='"+pageScript+"("+ parseInt(parseInt(currentPageNo) + 1)+");return false;'>&gt;</a>"
	 }else {
        pageHtml += "<a href='#' onclick='"+pageScript+"("+ parseInt(parseInt(currentPageNo) + 1)+");return false;'>&gt;</a>"
	 }
    if (parseInt(totalPageCount) > parseInt(pageSize)  ){
      pageHtml += "<a href='#' onclick='"+pageScript+"("+ totalPageCount +");return false;'>&raquo;</a>";
	 }else{
      pageHtml += "<a href='#' >&raquo;</a>";
	 }	
    return pageHtml;
}