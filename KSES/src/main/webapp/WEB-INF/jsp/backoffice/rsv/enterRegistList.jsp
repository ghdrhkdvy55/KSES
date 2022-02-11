<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!-- JQuery Grid -->
<link rel="stylesheet" href="/resources/jqgrid/src/css/ui.jqgrid.css">
<script type="text/javascript" src="/resources/jqgrid/src/i18n/grid.locale-kr.js"></script>
<script type="text/javascript" src="/resources/jqgrid/js/jquery.jqGrid.min.js"></script>
<style type="text/css">
.ui-jqgrid .ui-jqgrid-htable th div{
	outline-style: none;
	height: 30px;
}
.ui-jqgrid tr.jqgrow {
	outline-style: none;
	height: 30px;
}
</style>
<!-- //contents -->
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>고객 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">입장 등록 관리</li>
	</ol>
</div>
<h2 class="title">입장 등록 관리</h2>
<div class="clear"></div>
<div class="dashboard">
    <div class="boardlist">
        <div class="whiteBox searchBox">
            <div class="top">
      			<!--// Date Picker -->
				<div>
              		<p>지점</p>
              		<select id="searchCenterCd">
						<option value="">지점 선택</option>
						<c:forEach items="${centerInfo}" var="centerInfo">
							<option value="${centerInfo.center_cd}"><c:out value='${centerInfo.center_nm}'/></option>
						</c:forEach>
              		</select>
	              	<p>검색어</p>
	              	<input type="text" id="searchKeyword" placeholder="검색어를 입력하세요.">
				</div>
			</div>
	
            <div class="inlineBtn">
                <a href="javascript:fnSearch(1);" class="grayBtn">검색</a>
            </div>
        </div>
        <div class="left_box mng_countInfo">
			<p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
        <div class="right_box">
        </div>
        <div class="clear"></div>
        <div class="whiteBox">
            <table id="mainGrid"></table>
            <div id="pager" class="scroll" style="text-align:center;"></div>  
        </div>
    </div>
</div>
<!-- contents//-->
<!-- //popup -->
<div data-popup="popupConfirm" class="popup m_pop">
      <div class="pop_con">
        <a id="a_closePop" class="button b-close">X</a>
        <p class="pop_tit">메세지</p>
        <p class="pop_wrap"><span></span></p>
        <div class="right_box">
		  <button class="blueBtn" style="cursor:pointer;">예</button>
          <a href="javascript:$('[data-popup=popupConfirm]').bPopup().close();" class="grayBtn">아니요</a>
      </div>
      </div>
</div>
<!-- popup// -->
<script type="text/javascript" src="/resources/js/temporary.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		if($("#loginAuthorCd").val() != "ROLE_ADMIN" && $("#loginAuthorCd").val() != "ROLE_SYSTEM") {
			$("#searchCenterCd").val($("#loginCenterCd").val()).trigger('change');
			$(".top > div > p").eq(0).hide();
			$(".top > div > select").eq(0).hide();
		}
		EgovJqGridApi.mainGrid([
			{label: 'resv_seq', key: true, name:'resv_seq', align:'center', hidden:true},
			{label: '지점', name:'center_nm', align:'center'},
			{label: '좌석정보', name:'seat_nm', align:'center'},
			{label: '구역등급', name:'part_class', align:'center'},					
			{label: '예약번호', name:'resv_seq', align:'center'},
			{label: '아이디', name:'user_id', align:'center'},
			{label: '이름', name:'user_nm', align:'center', formatter:fnMasking},
			{label: '전화번호', name:'user_phone', align:'center', formatter:fnMasking},
			{label: '금액', name: 'resv_pay_cost', align:'center'},
			{label: '신청일자', name:'resv_req_date', align:'center'},
			{label: '예약일자', name:'resv_end_dt', align:'center'},
			{label: '결제구분', name: 'resv_pay_dvsn_text', align:'center'},
			{label: '예약상태', name:'resv_state_text', align:'center', hidden:true},
			{label: '시범구분', name: 'center_pilot_yn', align:'center', hidden:true},
			{label: '등록', name: 'enter_regist', align:'center', formatter:fnEnterRegistButton}
		], false, true, fnSearch);
		
    	$("body").keydown(function (key) {
        	if(key.keyCode == 13){
        		fnSearch();
        	}
    	});
	});
	
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val(),
			searchCenterCd: $('#searchCenterCd').val(),
			centerRegistSelect: "centerRegistSelect"
		};
		EgovJqGridApi.mainGridAjax('/backoffice/rsv/enterRegistAjax.do', params, fnSearch, fnSubGrid);
	}
	
	function fnSubGrid(id, resvSeq) {
		let subGridId = id + '_t';
		$('#'+id).empty().append('<table id="'+ subGridId + '" class="scroll"></table>');
		EgovJqGridApi.subGrid(subGridId, 
		[
			{label: 'qr_check_seq', key: true, name:'qr_check_seq', align:'center', hidden:true},
			{label: '체크 구분', name:'inout_dvsn_text', align:'center'},
			{label: '체크인 시간', name:'qr_check_tm', align:'center'},
			{label: '입장 관리자', name:'enter_admin_id', align:'center'},		
			{label: '통신시간 ', name:'rcv_dt', align:'center'},
			{label: '통신결과', name:'rcv_cd', align:'center'}
		], '/backoffice/rsv/enterRegistListAjax.do', {
			resvSeq: resvSeq
		});
	}
	
	function fnEnterRegistButton(cellvalue, options, rowObject) {
		return '<a href="javascript:fnEnterRegist(&#39;'+rowObject.resv_seq+'&#39;,&#39;'+rowObject.resv_pay_dvsn_text+'&#39;,&#39;'+rowObject.center_pilot_yn+'&#39;);" class="blueBtn">입장 등록</a>';	
	}
	
	
 	function fnEnterRegist(resvSeq,resvPayDvsn,centerPilotYn){	
		if (resvPayDvsn != '결제' && centerPilotYn == 'Y') { 		 	
 			//toastr.warning('정렬 순서를 입력해 주세요.');
 			common_popup('미결제 상태의 예약정보입니다.', 'N', '');
 			return;
 		}
 		bPopupConfirm('수동 입장 등록', '입장 등록하시겠습니까?', function() {					
 			var url = "/backoffice/rsv/attendInfoUpdate.do";
 			var params = {
 				"mode" : "Manual",
 				"resvSeq" : resvSeq,
 				"inoutDvsn" : "IN"
 			}
 			
 			fn_Ajax
 			(
 			    url,
 			    "POST",
 				params,
 				false,
 				function(result) {
 					if (result.status == "SUCCESS") {
 						common_popup("입장 정보가 정상적으로 등록되었습니다.", "Y" , "");
 						fnSearch(1);
 					} else {
 						common_popup("에러가 발생하였습니다.", "" ,"");
 					}
 				},
 				function(request) {
 					common_popup("ERROR : " +request.status, "N", "");	       						
 				}    		
 			);			
 		});
 	}
		

	function bPopupConfirm(title, message, fnOk) {
		let $popup = $('[data-popup=popupConfirm]');
		$popup.find('.pop_tit').text(title);
		$popup.find('.pop_wrap span').html(message);
		$popup.find('.blueBtn').off('click').click(function() {
			$('[data-popup=popupConfirm]').bPopup().close();
			fnOk();
		});
		$popup.bPopup();
	}
	
	function fnMasking(cellvalue, options, rowObject) {
		let name = options.colModel.name;
		let item = rowObject;
		let result = ''; 

		if(name === 'user_nm') {
			result = item.user_nm.replace(/(?<=.{1})./gi, "*");
		} else if(name === 'user_phone') {
			if(item.user_phone.length == 13){
				result = item.user_phone.replace(/-[0-9]{4}-/g, "-****-");
			}else {
				result = item.user_phone.replace(/-[0-9]{3}-/g, "-***-");
			}
		}
		
		return result;
	}
</script>
<c:import url="/backoffice/inc/popup_common.do" />