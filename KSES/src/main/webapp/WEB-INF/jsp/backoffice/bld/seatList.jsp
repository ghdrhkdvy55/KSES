<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<input type="hidden" id="seatCd" name="seatCd">
<input type="hidden" id="mode" name="mode">
<input type="hidden" id="pageIndex" name="pageIndex">
<input type="hidden" id="selectFloorCd" name="selectFloorCd">
<input type="hidden" id="selectPartCd" name="selectPartCd">
<input type="hidden" id="changeFloorCd" name="changeFloorCd">
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>시설 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">좌석 관리</li>
	</ol>
</div>
<h2 class="title">좌석 관리</h2>
<div class="clear"></div>
<div class="dashboard">
	<div class="boardlist">
        <div class="whiteBox searchBox">
			<div class="sName">
            	<h3>검색 옵션</h3>
            </div>
			<div class="top">
            	<p>지점</p>
             	<select id="searchCenterCd" onChange="fnCenterChange('search')">
                    <option value="">선택</option>
                     <c:forEach items="${centerList}" var="centerList">
						<option value="${centerList.center_cd}"><c:out value='${centerList.center_nm}'/></option>
                     </c:forEach>
            	</select>
            	<p>층</p>
            	<select id="searchFloorCd" onChange="fnFloorChange('search')">
					<option value="">선택</option>
            	</select>
            	<p>구역</p>
            	<select id="searchPartCd">
              		<option value="">선택</option>
            	</select>
            	<p>검색어</p>
            	<input type="text" id="searchKeyword" placeholder="검색어를 입력하세요.">
          	</div>
          	
          	<div class="inlineBtn">
            	<a href="javascript:fnSearch(1);" class="grayBtn">검색</a>
          	</div>
        </div>

		<div class="right_box">
			<a data-popup-open="bld_seat_add" onclick="fnSeatInfo();" class="blueBtn">좌석 등록</a>
			<a onClick="fnSeatDelete();" class="grayBtn">삭제</a>
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
<!-- // 좌석 추가 팝업 -->
<div data-popup="bld_seat_add" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
		<h2 class="pop_tit">좌석 정보 등록(수정)</h2>
		<div class="pop_wrap">
			<form>
			<input type="hidden" name="mode" value="Ins">
			<input type="hidden" name="seatCd">
			<table class="detail_table">
				<tbody>
					<tr>
						<th>구역 선택</th>
							<td colspan="3">
	                     	<select name="centerCd" onChange="fnCenterChange('popup')">
		                        <option value="">선택</option>
								<c:forEach items="${centerList}" var="centerList">
									<option value="${centerList.center_cd}"><c:out value='${centerList.center_nm}'/></option>
								</c:forEach>
	                    	</select>
                        	<select name="floorCd" onChange="fnFloorChange('popup')">
                          		<option value="">선택</option>
                        	</select>
                        	<select name="partCd">
                          		<option value="">선택</option>
                        	</select>
						</td>
                  	</tr>
                  	<tr>
                    	<th>좌석명</th>
                    	<td><input type="text" name="seatNm"></td>
                    	<th>사용유무</th>
                    	<td>
                    		<label for="useYn_Y"><input id="useYn_Y" type="radio" name="useYn" value="Y" checked>Y</label>
                    		<label for="useYn_N"><input id="useYn_N" type="radio" name="useYn" value="N">N</label>
                    	</td>
                  	</tr>
              	</tbody>
			</table>
			</form>
      	</div>
		<popup-right-button />
  	</div>
</div>
<!-- 좌석 추가 팝업 // -->
<!-- poopup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		if($("#loginAuthorCd").val() != "ROLE_ADMIN" && $("#loginAuthorCd").val() != "ROLE_SYSTEM") {
			$("#searchCenterCd").val($("#loginCenterCd").val()).trigger('change');
			$(".top > p").eq(0).hide();
			$(".top > select").eq(0).hide();
		}
		
		// 메인 JqGrid 정의
        EgovJqGridApi.mainGrid([
			{label: '좌석코드',  	name: 'seat_cd', 		hidden:true, key: true},
			{label: '지점코드', 	name: 'center_cd', 		hidden:true},
			{label: '층코드', 	name: 'floor_cd', 		hidden:true},
			{label: '구역코드', 	name: 'part_cd', 		hidden:true},
			{label: '지점', 		name: 'center_nm', 		align:'center'},
			{label: '층수', 		name: 'floor_nm', 		align:'center'},
			{label: '구역', 		name: 'part_nm', 		align:'center'},
			{label: '좌석명', 	name: 'seat_nm', 		align:'center'},
			{label: '좌석등급', 	name: 'seat_class_txt', align:'center'},
			{label: '금액', 		name: 'part_pay_cost',  align:'center'},
			{label: '정렬순서', 	name: 'seat_order',  	align:'center'},
			{label: '사용유무', 	name: 'use_yn', 		align:'center'},
			{label: '수정일자', 	name: 'last_updt_dtm', 	align:'center'},
			{label: '수정자', 	name: 'last_updusr_id', align:'center'},
			{label: '수정',      name: 'update_btn',		align:'center', width: 50, fixed: true, sortable: false, 
       			formatter: (c, o, row) => '<a href="javascript:fnSeatInfo(\''+ row.seat_cd + '\');" class="edt_icon"></a>'
       		} 
        ], false, false, fnSearch);
	});
	
	// 메인 목록 검색
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val(),
			searchCondition : $('#searchCondition').val(),
			searchCenterCd : $('#searchCenterCd').val(),
			searchFloorCd : $('#searchFloorCd').val(),
			searchPartCd : $('#searchPartCd').val(),
		};
		EgovJqGridApi.mainGridAjax('/backoffice/bld/seatListAjax.do', params, fnSearch);
	}
	
	function fnSeatInfo(rowId) {
		let $popup = $('[data-popup=bld_seat_add]');
		let $form = $popup.find('form:first');
		if (rowId === undefined || rowId === null) {
			$popup.find('h2:first').text('좌석정보 등록');
			$popup.find('button.blueBtn').off('click').click(fnSeatInsert);
			$form.find(':text').val('');
			$form.find(':hidden[name=mode]').val('Ins');
			$form.find(':hidden[name=seatCd]').val('');
			if($('#loginAuthorCd').val() != "ROLE_ADMIN" && $('#loginAuthorCd').val() != 'ROLE_SYSTEM') {
				$form.find('select[name=centerCd] option:first').prop('selected', true);
			}
			
			$form.find('select[name=centerCd] option:first').prop('selected', true);
			$form.find('select[name=floorCd] option:first').prop('selected', true);
			$form.find('select[name=floorCd] option:not(:first)').remove();
			$form.find('select[name=partCd] option:first').prop('selected', true);
			$form.find('select[name=partCd] option:not(:first)').remove();
			$form.find(':radio[name=useYn]:first').prop('checked', true);
		} else {
            let rowData = EgovJqGridApi.getMainGridRowData(rowId);
			$popup.find('h2:first').text('좌석정보 수정');
			$popup.find('button.blueBtn').off('click').click(fnSeatUpdate);
			$form.find(':hidden[name=mode]').val('Edt');
			$form.find(':hidden[name=seatCd]').val(rowData.seat_cd);
			$form.find(':text[name=seatNm]').val(rowData.seat_nm);
			$form.find('select[name=centerCd]').val(rowData.center_cd).trigger('change');
			$form.find('select[name=floorCd]').val(rowData.floor_cd).trigger('change');
			$form.find('select[name=partCd]').val(rowData.part_cd);
			
            EgovJqGridApi.selection('mainGrid', rowId);
		}
		$popup.bPopup();
	}
	
	function fnCenterChange(division) {
		let params = new Object();
		if(division === 'search') {
			params.centerCd = $('#searchCenterCd').val();
			$('#searchPartCd').find('option:first').prop('selected', true);
			$('#searchPartCd').find('option:not(:first)').remove();
			fnComboList($('#searchFloorCd'), '/backoffice/bld/floorComboInfo.do', params);	
		} else {
			let $popup = $('[data-popup=bld_seat_add]');
			$popup.find('select[name=partCd] option:first').prop('selected', true);
			$popup.find('select[name=partCd] option:not(:first)').remove();
			params.centerCd = $popup.find('select[name=centerCd]').val();
			fnComboList($popup.find('select[name=floorCd]'), '/backoffice/bld/floorComboInfo.do', params);
		}		
	}
	
	function fnFloorChange(division) {
		let params = new Object();
		if(division === 'search') {
			params.floorCd = $('#searchFloorCd').val();
			fnComboList($('#searchPartCd'), '/backoffice/bld/partInfoComboList.do', params);	
		} else {
			let $popup = $('[data-popup=bld_seat_add]');
			params.floorCd = $popup.find('select[name=floorCd]').val();
			fnComboList($popup.find('select[name=partCd]'), '/backoffice/bld/partInfoComboList.do', params);
		}	
	}
	
	function fnComboList(el, url, param) {
		let resultlist = uniAjaxReturn(url, 'GET', false, param, 'lst');

		if(resultlist.length > 0){
			let obj = resultlist;
			el.empty();
			el.append('<option value="">선택</option>');
				
			for (var i in obj) {
				var array = Object.values(obj[i])
				el.append('<option value="' + array[0]+'">' + array[1] + '</option>');
			}
		} else {
			el.empty();
			el.append('<option value="">선택</option>');
		}
	}
	
	function fnSeatInsert() {
		let $popup = $('[data-popup=bld_seat_add]');
		if ($popup.find(':text[name=seatNm]').val() === '') {
			toastr.warning('좌석명을 입력해주세요.');
			return;
		}
		if ($popup.find('select[name=floorCd]').val() === '') {
			toastr.warning('층을 선택해 주세요.');
			return;	
		}
		if ($popup.find('select[name=partCd]').val() === '') {
			toastr.warning('구역을 선택해 주세요.');
			return;
		}
		bPopupConfirm('좌석정보 등록', '등록 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bld/seatInfoUpdate.do',
                $popup.find('form:first').serializeObject(),
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
	
	function fnSeatUpdate() {
		let $popup = $('[data-popup=bld_seat_add]');
		if ($popup.find(':text[name=seatNm]').val() === '') {
			toastr.warning('좌석명을 입력해주세요.');
			return;
		}
		if ($popup.find('select[name=floorCd]').val() === '') {
			toastr.warning('층을 선택해 주세요.');
			return;	
		}
		if ($popup.find('select[name=partCd]').val() === '') {
			toastr.warning('구역을 선택해 주세요.');
			return;
		}
		bPopupConfirm('좌석정보 수정', '수정 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bld/seatInfoUpdate.do',
                $popup.find('form:first').serializeObject(),
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
	
	// 권한 삭제 확인
	function fnSeatDelete() {
        let rowId = EgovJqGridApi.getMainGridSingleSelectionId();
        if (rowId === null) {
            toastr.warning('좌석정보를 선택해 주세요.');
            return false;
        }
		bPopupConfirm('좌석정보 삭제', '해당 정보를 삭제할 경우 시스템에 영향이 있을 수 있습니다.<br>정말로 삭제하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bld/seatInfoDelete.do', {
					seatCd : rowId
				},
				null,
				function(json) {
					toastr.success(json.message);
					fnSearch(1);
                    $popup.bPopup().close();
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
</script>