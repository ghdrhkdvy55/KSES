<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript" src="/resources/jqgrid/src/i18n/grid.locale-kr.js"></script>
<script type="text/javascript" src="/resources/jqgrid/js/jquery.jqGrid.min.js"></script>
<!-- timepicker -->
<script src="/resources/js/jquery.timepicker.js"></script>
<link rel="stylesheet" href="/resources/jqgrid/src/css/ui.jqgrid.css">
<link rel="stylesheet" href="/resources/css/jquery.timepicker.css">
<style type="text/css">
.ui-jqgrid .ui-jqgrid-htable th div {
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
		<li>기초 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">환경 설정</li>
	</ol>
</div>
<h2 class="title">환경 설정</h2>
<div class="clear"></div>
<div class="dashboard">
	<div class="boardlist">
   		<div class="whiteBox">
        	<table class="system_info_table">
				<tbody class="setTxt">
					<tr>
                        <th>사이트 명</th>
                        <td style="text-align:left;"><input type="text" id="comTitle" name="comTitle" value="${result.comTitle}"></td>
						<td colspan="2"></td>
                    </tr>
					<tr>
						<th>1차 자동취소 사용여부</th>
	                  	<td style="text-align:left;">	                  	
							<input 
								style="width:0; left:0;"
								id="autoCancelR1UseYn_Y"
								name="autoCancelR1UseYn"  
								type="radio" 
								value="Y" 
								<c:if test="${result.autoCancelR1UseYn == 'Y' }"> checked </c:if>
							>
                            <label for="autoCancelR1UseYn_Y">Y</label>
                    		
                    		<input 
								style="width:0; left:0;"
								id="autoCancelR1UseYn_N"
								name="autoCancelR1UseYn" 
								type="radio"
								value="N" 
								<c:if test="${result.autoCancelR1UseYn == 'N' }"> checked </c:if>
							>
                            <label for="autoCancelR1UseYn_N">N</label>
	                  	</td>
						<th>2차 자동취소 사용여부</th>
	                  	<td style="text-align:left;">	                  	
							<input 
								style="width:0; left:0;"
								id="autoCancelR2UseYn_Y"
								name="autoCancelR2UseYn" 
								type="radio" 
								value="Y" 
								<c:if test="${result.autoCancelR2UseYn == 'Y' }"> checked </c:if>
							>
                            <label for="autoCancelR2UseYn_Y">Y</label>
                    		
                    		<input 
								style="width:0; left:0;"
								id="autoCancelR2UseYn_N"
								name="autoCancelR2UseYn"  
								type="radio" 
								value="N" 
								<c:if test="${result.autoCancelR2UseYn == 'N' }"> checked </c:if>
							>
                            <label for="autoCancelR2UseYn_N">N</label>
                    		
	                  	</td>
                    </tr>
					<tr>
						<th>비회원 예약 여부</th>
	                  	<td style="text-align:left;">	                  	
							<input 
								style="width:0; left:0;"
								id="guestResvPossibleYn_Y"
								name="guestResvPossibleYn" 
								type="radio" 
								value="Y" 
								<c:if test="${result.guestResvPossibleYn == 'Y' }"> checked </c:if>
							>
                            <label for="guestResvPossibleYn_Y">Y</label>
                    		
                    		<input 
								style="width:0; left:0;"
								id="guestResvPossibleYn_N"
								name="guestResvPossibleYn" 
								type="radio"  
								value="N" 
								<c:if test="${result.guestResvPossibleYn == 'N' }"> checked </c:if>
							>
                            <label for="guestResvPossibleYn_N">N</label>
	                  	</td>
	                  	<th>스피드온 자동결제</th>
	                  	<td style="text-align:left;"><button class="blueBtn" onclick="fnAutoPaymentInfo();">설정</button></td>
                    </tr>
            	</tbody>
        	</table>
    	</div>
    	<div class="center_box">
        	<a href="javascript:fnSystemInfoUpdate();" class="blueBtn">저장</a> 
    	</div>
	</div>
</div>

<!-- 자동결제정보 팝업 -->
<div data-popup="bas_autopay_info" class="popup">
	<div class="pop_con">
		<h2 class="pop_tit">자동 결제정보</h2>
		<div class="pop_wrap">
			<div style="width:700px;">
				<table id="mainGrid"></table>
				<div id="pager"></div>
			</div>
		</div>
		<popup-right-button okText="저장" clickFunc="fnAutoPaymentUpdate();" />
	</div>
</div>
<!-- contents//-->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function () {
		let timeEdit = {size: 5, maxlength: 5};
		let useEdit = {value: 'Y:사용;N:사용안함'};
		
		// 자동결제관리 JqGrid 정의
		EgovJqGridApi.mainGrid([
	        { label: '자동결제요일', 	name: 'auto_payment_day', 		key: true, hidden:true },
	        { label: '요일', 			name: 'auto_payment_day_text', 	align: 'center', sortable: false },
	        { label: '자동결제시작시간',	name: 'auto_payment_open_tm', 	align: 'center', sortable: false, editable: true, editoptions: timeEdit},
	        { label: '자동결제종료시간',	name: 'auto_payment_close_tm', 	align: 'center', sortable: false, editable: true, editoptions: timeEdit},
	        { label: '사용여부', 		name: 'use_yn', align: 'center', sortable: false, formatter: 'select', editable: true, edittype: 'select', editoptions: useEdit},
		]).jqGrid('setGridParam', {
	        cellEdit: true,
	        cellsubmit: 'clientArray'
	    });
    });

	// 휴일 적용 지점 목록
	function fnAutoPaymentInfo(pageNo) {
		let $popup = $('[data-popup=bas_autopay_info]');
		let params = {
			pageIndex: pageNo,
			pageUnit: $('#pager .ui-pg-selbox option:selected').val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/bas/autoPaymentInfoListAjax.do', params, fnAutoPaymentInfo);
		$popup.bPopup();
	}
	
	// 휴일 적용 지점 목록
	function fnAutoPaymentUpdate() {
		let $popup = $('[data-popup=bas_autopay_info]');
		let changedArr = $(MainGridSelector).jqGrid('getChangedCells', 'all');
		
		if (changedArr.length === 0) {
			toastr.warning('수정된 목록이 없습니다.');
			return;
		}
		bPopupConfirm('스피드온 자동결제 정보', changedArr.length +'건에 대해 수정 하시겠습니까?', function() {
			let params = new Array();
		    changedArr.forEach(x => params.push({
		        autoPaymentDay: x.auto_payment_day,
		        autoPaymentOpenTm: x.auto_payment_open_tm.replace(/\:/g,''),
		        autoPaymentCloseTm: x.auto_payment_close_tm.replace(/\:/g,''),
		        useYn: x.use_yn
		    }));
			
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/autoPaymentInfoUpdate.do',
				params,
				null,
				function(json) {
					toastr.success(json.message);
					$popup.bPopup().close();
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	
	function fnSystemInfoUpdate(){
		if ($('#comTitle').val() === '') {
			toastr.warning('사이트명을 입력해주세요.');
			return;
		}
		
    	let params = {   
			'comTitle' : $.trim($('#comTitle').val()),
			'guestResvPossibleYn' : $('input[name=guestResvPossibleYn]:checked').val(),
			'autoCancelR1UseYn' : $('input[name=autoCancelR1UseYn]:checked').val(),
			'autoCancelR2UseYn' : $('input[name=autoCancelR2UseYn]:checked').val()
		}; 
    	
		EgovIndexApi.apiExecuteJson(
			'POST',
			'/backoffice/bas/systemInfoUpdate.do',
			params,
			null,
			function(json) {
				toastr.success(json.message);
				setTimeout(function () {
					location.reload();
				}, 2000);
			},
			function(json) {
				toastr.error(json.message);
			}
		);
	}
</script>