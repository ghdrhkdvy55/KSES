<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- JQuery Grid -->
<link rel="stylesheet" type="text/css" href="/resources/jqgrid/src/css/ui.jqgrid.css">
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
		<li>기초 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">장비 관리</li>
	</ol>
</div>
<h2 class="title">장비 관리</h2>
<div class="clear"></div>
<div class="dashboard">
	<div class="boardlist">
		<div class="whiteBox searchBox">
			<div class="top">
				<p>검색어</p>
				<select id="searchMachDvsn">
					<option value="">선택</option>
					<c:forEach items="${machInfo}" var="machInfo">
						<option value="${machInfo.code}">${machInfo.codenm}</option>
					</c:forEach>
				</select>
                <select id="searchCenterCd">
					<option value="">지점 선택</option>
					<c:forEach items="${centerInfo}" var="centerInfo">
						<option value="${centerInfo.center_cd}">${centerInfo.center_nm}</option>
					</c:forEach>
		        </select>
                <select id="searchCondition">
                    <option value="ALL">전체</option>
					<option value="TICKET_MCHN_SNO">장비Serial</option>
					<option value="TICKET_MCHN_REMARK">위치</option>
                </select>
                <input type="text" id="searchKeyword" placeholder="검색어를 입력하새요.">
            </div>
            <div class="inlineBtn ">
                <a href="javascript:fnSearch(1);" class="grayBtn">검색</a>
            </div>
        </div>
		<div class="left_box mng_countInfo">
			<p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
		<div class="right_box">
			<a href="javascript:fnKioskInfo();" class="blueBtn">장비 등록</a>
			<a href="javascript:fnKioskDelete();" class="grayBtn">삭제</a>
		</div>
		<div class="clear"></div>
		<div class="whiteBox">
			<table id="mainGrid"></table>
			<div id="pager"></div> 
		</div>
	</div>
</div>
<!-- contents// -->
<!-- //poopup -->
<!-- 무인발권기 정보 추가 팝업-->
<div data-popup="bas_kiosk_add" class="popup m_pop">
	<div class="pop_con">
		<a class="button b-close">X</a>
		<h2 class="pop_tit">장비 정보 등록</h2>
		<div class="pop_wrap">
			<form>
			<input type="hidden" name="mode" value="Ins">
			<table class="detail_table">
				<tbody>
					<tr>
						<th>장비 Serial</th>
	                    <td>
	                    	<input type="text" name="ticketMchnSno">
	                    	<span id="sp_Unqi">
	                            <a href="javascript:fnIdCheck()" class="blueBtn">중복확인</a>
	                            <input type="hidden" id="idCheck" value="N">
                            </span>
	                    </td>
					</tr>
					<tr>
				        <th>장비구분</th>
			            <td>
							<select name="machDvsn">
								<option value="">선택</option>
								<c:forEach items="${machInfo}" var="machInfo">
									<option value="${machInfo.code}">${machInfo.codenm}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
				        <th>지점명</th>
			            <td>
			            	<select name="centerCd" onchange="fnFloorChange()">
								<option value="">지점 선택</option>
								<c:forEach items="${centerInfo}" var="centerInfo">
									<option value="${centerInfo.center_cd}">${centerInfo.center_nm}</option>
								</c:forEach>
			                 </select>
						</td>
					</tr>
					<tr>
				        <th>층수</th>
			            <td>
							<select name="floorCd">
								<option value="">선택</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>사용 유무</th>
					    <td>
				            <span>
			                    <input type="radio" name="useYn" value="Y">사용</input>
							</span>
						    <span>
					            <input type="radio" name="useYn" value="N">사용 안함</input>
			                </span>
		                </td>
	                </tr>
	                <tr>
						<th>비고</th>
					    <td>
				            <input type="text" name="machEtc1">
		                </td>
	                </tr>
                    <tr>
                    	<th>설명</th>
						<td>
					        <textarea name="ticketMchnRemark" rows="5"></textarea>
				        </td>
			        </tr>
				</tbody>
			</table>
			</form>
		</div>
	    <div class="right_box">
	    	<button type="button" class="blueBtn">저장</button>
	    	<button type="button" class="grayBtn b-close">취소</button>
		</div>
		<div class="clear"></div>
	</div>
</div>
<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() { 
		// 메인 목록 정의
		EgovJqGridApi.mainGrid([
			{ label: '장비 Serial', name:'ticket_mchn_sno', align:'center', key:true},
			{ label: '구분', name:'code_nm', align:'center'},
			{ label: '구분코드', name:'code', align:'center', hidden: true},
			{ label: '지점명', name:'center_nm', align:'center'},
			{ label: '지점 코드', name:'center_cd', align:'center', hidden: true},
			{ label: '사용 층수', name:'floor_nm', align:'center'},
			{ label: '층 코드', name:'floor_cd', align:'center', hidden: true},
			{ label: '위치', name:'ticket_mchn_remark', align:'left'},
			{ label: '사용 여부', name:'use_yn', align:'center'},
			{ label: '사용 여부', name:'use_yn_value', align:'center', hidden: true},
			{ label: '비고', name:'mach_etc1', align:'left', hidden: true},
			{ label: '수정일자', name:'last_updt_dtm', align:'center', formatter: 'date'},
			{ label: '수정', align:'center', width: 50, fixed: true, formatter: (c, o, row) =>
        	'<a href="javascript:fnKioskInfo(\''+ row.ticket_mchn_sno +'\');" class="edt_icon"></a>'}
		], true, false, fnSearch);
 	});
	// 메인 목록 검색
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val(),
			searchMachDvsn : $("#searchMachDvsn").val(),
			searchCenterCd : $("#searchCenterCd").val(),
			searchCondition : $("#searchCondition").val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/bas/kioskListAjax.do', params, fnSearch);
		/* EgovJqGridApi.mainGridDetail(fnKioskInfo); */
	}
    // 장비 정보 팝업 정의
	function fnKioskInfo(rowId) {
		let $popup = $('[data-popup=bas_kiosk_add]');
		let $form = $popup.find('form:first');
		if (rowId === undefined || rowId === null) {
			$popup.find('h2:first').text('장비 정보 등록');
			$popup.find('span#sp_Unqi').show();
			$popup.find('button.blueBtn').off('click').click(fnKioskInsert);
			$form.find(':hidden[name=mode]').val('Ins');
			$form.find(':text').val('');
			$form.find(':hidden#idCheck').val('N');
			$form.find('select').prop('selectedIndex', 0);
			$form.find('textarea[name=ticketMchnRemark]').val('');
			$form.find(':text[name=ticketMchnSno]').removeAttr('readonly');
			$form.find(':radio[name=useYn]:first').prop('checked', true);
		}
		else {
			let rowData = EgovJqGridApi.getMainGridRowData(rowId);
			$popup.find('h2:first').text('장비 정보 수정');
			$popup.find('span#sp_Unqi').hide();
			$popup.find('button.blueBtn').off('click').click(fnKioskUpdate);
			$form.find(':hidden[name=mode]').val('Edt');
			$form.find(':text[name=ticketMchnSno]').prop('readonly', true).val(rowData.ticket_mchn_sno);
			$form.find('select[name=machDvsn]').val(rowData.code);
			$form.find('select[name=centerCd]').val(rowData.center_cd).trigger('change');
			$form.find('select[name=floorCd]').val(rowData.floor_cd).prop('selected', true);
			$form.find(':radio[name=useYn][value='+ rowData.use_yn_value +']').prop('checked', true);
			$form.find(':text[name=machEtc1]').val(rowData.mach_etc1);
			$form.find('textarea[name=ticketMchnRemark]').val(rowData.ticket_mchn_remark);
		}
		$popup.bPopup();
	}
     
	// 장비 시리얼 중복 체크
	function fnIdCheck() {
		let $popup = $('[data-popup=bas_kiosk_add]');
		if ($popup.find(':text[name=ticketMchnSno]').val() === '') {
			toastr.warning('장비 시리얼을 입력해주세요.');
			return;
		}
		EgovIndexApi.apiExecuteJson(
			'GET',
			'/backoffice/bas/kisokSerialCheck.do', {
				ticketMchnSno: $popup.find(':text[name=ticketMchnSno]').val()
			},
			null,
			function(json) {
				$popup.find(':hidden#idCheck').val('Y');
				toastr.info(json.message);
			},
			function(json) {
				toastr.warning(json.message);
			}
		);
	}

	// 장비 정보 등록
	function fnKioskInsert() {
		let $popup = $('[data-popup=bas_kiosk_add]');
		if ($popup.find(':text[name=ticketMchnSno]').val() === '') {
			toastr.warning('장비 시리얼을 입력해 주세요.');
			return;
		}
		if ($popup.find(':hidden#idCheck').val() !== 'Y') {
			toastr.warning('중복체크가 안되었습니다.');
			return;	
		}
		if ($popup.find('select[name=machDvsn]').val() === '') {
			toastr.warning('장비 구분을 선택해 주세요.');
			return;
		}
		if ($popup.find('select[name=centerCd]').val() === '') {
			toastr.warning('지점을 선택해 주세요.');
			return;
		}
		if ($popup.find('select[name=floorCd]').val() === '') {
			toastr.warning('층을 선택해 주세요.');
			return;
		}
		
		bPopupConfirm('장비 등록', '등록 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/kioskUpdate.do', 
				$popup.find('form').serializeObject(),
				null,
				function(json) {
					toastr.success(json.message);
					$popup.bPopup().close();
					fnSearch(1);
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	
	// 장비정보 수정
	function fnKioskUpdate() {
		let $popup = $('[data-popup=bas_kiosk_add]');
		if ($popup.find('select[name=machDvsn]').val() === '') {
			toastr.warning('장비 구분을 선택해 주세요.');
			return;
		}
		if ($popup.find('select[name=centerCd]').val() === '') {
			toastr.warning('지점을 선택해 주세요.');
			return;
		}
		if ($popup.find('select[name=floorCd]').val() === '') {
			toastr.warning('층을 선택해 주세요.');
			return;
		}
		
		bPopupConfirm('장비 정보 수정', '<b>'+ $popup.find(':text[name=ticketMchnSno]').val() +'</b> 수정 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/kioskUpdate.do', 
				$popup.find('form').serializeObject(),
				null,
				function(json) {
					toastr.success(json.message);
					$popup.bPopup().close();
					fnSearch(1);
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	
	// 장비정보 삭제
	function fnKioskDelete() {
		let rowIds = EgovJqGridApi.getMainGridMutipleSelectionIds();
		if (rowIds.length === 0) {
			toastr.warning('목록을 선택해 주세요.');
			return false;
		}
		bPopupConfirm('장비정보 삭제', '삭제 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/kioskDelete.do', {
					ticketMchnSno: rowIds.join(',')
				},
				null,
				function(json) {
					toastr.success(json.message);
					fnSearch(1);
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	
	// 지점 층정보 가져오기
	function fnFloorChange() {
		let $popup = $('[data-popup=bas_kiosk_add]');
		let $form = $popup.find('form:first');
		
		if ($form.find('select[name=centerCd]').val() != ""){
			var _url = "/backoffice/bld/floorComboInfo.do";
			var _params = {"centerCd" : $form.find('select[name=centerCd]').val()};
			var returnVal = uniAjaxReturn(_url, "GET", false, _params, "lst");

			if (returnVal.length > 0){
				var obj  = returnVal;
				$form.find('select[name=floorCd]').empty();
				$form.find('select[name=floorCd]').append("<option value=''>선택</option>");
				for (var i in obj) {
					var array = Object.values(obj[i])
					$form.find('select[name=floorCd]').append("<option value='"+ array[0]+"'>"+array[1]+"</option>");
				}
			}
			else {
				//값이 없을때 처리 
				$form.find('select[name=floorCd]').empty();
			}
		} 
	}  
</script>