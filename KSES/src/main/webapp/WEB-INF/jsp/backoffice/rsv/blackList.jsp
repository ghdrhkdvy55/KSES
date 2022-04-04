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
<input type="hidden" id="mode" name="mode">
<input type="hidden" id="searchBlklstDvsn" name="searchBlklstDvsn" value="BLKLST_DVSN_1">
<div class="breadcrumb">
 	<ol class="breadcrumb-item">
 		<li>고객 관리&nbsp;&gt;&nbsp;</li>
 		<li class="active">출입 통제 관리</li>
 	</ol>
</div>
<h2 class="title">출입 통제 관리</h2>
<div class="clear"></div>
<div class="dashboard">
  	<div class="boardlist">
    	<div class="whiteBox searchBox">
        	<div class="sName">
            	<h3>검색 옵션</h3>
          	</div>
      		<div class="top">
        		<p>검색 구분</p>
        		<select id="searchCondition">
          			<option value="USER_ID">아이디</option>
          			<option value="USER_NM">이름</option>
          			<option value="USER_PHONE">전화번호</option>
        		</select>
        		<input type="text" id="searchKeyword" placeholder="검색어를 입력하세요.">
      		</div>
      		<div class="inlineBtn">
        		<a href="javascript:fnSearch();"class="grayBtn">검색</a>
      		</div>
    	</div>
    	
    	<div class="left_box mng_countInfo">
      		<p>총 : <span id="sp_totcnt">100</span>건</p>
    	</div>	
    	<div class="clear"></div>
    	
    	<div class="tabs blacklist">
      		<div id="BLKLST_DVSN_1" class="tab active" onclick="fnChangeBlackDvsn(this);">블랙리스트</div>
      		<div id="BLKLST_DVSN_2" class="tab" onclick="fnChangeBlackDvsn(this);">자가출입통제</div>
      		<div id="BLKLST_DVSN_3" class="tab" onclick="fnChangeBlackDvsn(this);">패널티 고객</div>
    	</div>
    	
    	<div class="right_box">
        	<a href="javascript:fnBlackInfo();" class="blueBtn">입장 제한 고객 등록</a>
        	<a href="javascript:fnBlackDelete();" class="grayBtn">삭제</a>
		</div>
		<div class="clear"></div>
    	
		<div class="whiteBox">
			<table id="mainGrid">
	        				
			</table>
			<div id="pager" class="scroll" style="text-align:center;"></div>     
					
			<div id="paginate"></div>
		</div>
	</div>
</div>
<!-- contents// -->
<!-- //popup -->
<!-- // 입장제한고객 등록 팝업 -->
<div id="blacklist_add" data-popup="rsv_blacklist_add" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
      	<h2 class="pop_tit">입장 제한 고객 등록</h2>
      	<div class="pop_wrap">
      		<form>
      		<input type="hidden" name="mode" value="Ins">
      		<input type="hidden" name="blklstSeq">
      		<input type="hidden" name="blklstCancelYn">
      		<table class="detail_table blacklist_add_table">
				<tbody>
                  	<tr>
                    	<th>회원 조회</th>
                    	<td>
                      		<select name="userSearchCondition">
                          		<option value="user_id">아이디</option>
                          		<option value="user_nm">이름</option>    
                          		<option value="user_phone">전화번호</option>             
                      		</select>
                      		<input type="text" name="userSearchKeyword">
                      		<a href="javascript:fnUserInfoPopup();" class="grayBtn">검색</a>
                    	</td>
                      	<th>아이디 </th>
                      	<td><input type="text" name="userId" readonly></td>
                  	</tr>
                  	<tr>
                      	<th>이름 </th>
                      	<td><input type="text" name="userNm" readonly></td>
                      	<th>전화번호 </th>
                      	<td><input type="text" name="userClphn" readonly></td>
                  	</tr>
                  	<tr>
                    	<th>제한 유형</th>
                    	<td>
                        	<select name="blklstDvsn">
                          		<option value="BLKLST_DVSN_1">블랙리스트</option>
                          		<option value="BLKLST_DVSN_2">자가출입통제</option>
                        	</select>
                    	</td>
                  	</tr>
					<tr>
                    	<th>상세 내역</th>
                      	<td colspan="3">
                        	<textarea style="width: 400px; height: 150px;" id="blklstReason" name="blklstReason">
                        
                        	</textarea>
                      	</td>
                  	</tr>
				</tbody>
			</table>
			</form>
      	</div>
		<popup-right-button />
  	</div>
</div>

<!-- 고객 검색 팝업 -->
<div data-popup="rsv_user_search" class="popup">
	<div class="pop_con">
		<h2 class="pop_tit">고객 검색</h2>
		<div class="pop_wrap">
			<fieldset class="whiteBox searchBox">
				<div class="top" style="padding:0;border-bottom:none;">
					<select id="searchUserGubun" style="width:100px;">
						<option value="">선택</option>
						<option value="user_id">아이디</option>
						<option value="user_nm">이름</option>
						<option value="user_phnum">전화번호</option>
					</select>
					<input type="text" id="pSearchKeyword" placeholder="검색어를 입력하세요.">
					<a href="javascript:fnUserInfoSearch(1);" class="grayBtn">검색</a>
				</div>
			</fieldset>
			<div style="width:570px;">
				<table id="popGrid"></table>
				<div id="popPager"></div>
			</div>
		</div>
		<popup-right-button okText="선택" clickFunc="fnInUserSearchInfo();" />
	</div>
</div>

<!-- 관리자 검색 팝업 // -->
<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		// 메인 JqGrid 정의
        EgovJqGridApi.mainGrid([
			{label: 'blklst_seq', name:'blklst_seq',       align:'center', hidden:true, key: true},
			{label: '이름', 		  name:'user_nm',  		   align:'center', hidden:true},
			{label: '통제유형', 	  name:'blklst_dvsn', 	   align:'center', hidden:true},
			{label: '통제사유', 	  name:'blklst_reason',    align:'center', hidden:true},
			{label: '해제여부', 	  name:'blklst_cancel_yn', align:'center', hidden:true},
			{label: '아이디',		  name:'user_id',  		   align:'center'},
			{label: '전화번호', 	  name:'user_phone',  	   align:'center', formatter: (c, o, row) =>
				row.user_phone.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3")
       		},
			{label: '유형', 		  name:'blklst_dvsn_txt',  align:'center'},
			{label: '노쇼카운트', 	  name:'user_noshow_cnt',  align:'center', fixed: true},
			{label: '최종 수정자', 	  name:'last_updusr_id',   align:'center', fixed: true},
			{label: '최종 수정일', 	  name:'last_updt_dtm',    align:'center', fixed: true},
			{label: '등록/해제', 	  align:'center', fixed: true, formatter: (c, o, row) =>
            	'<a href="javascript:fnChangeBlackState(\'' + row.blklst_seq + '\');" class="blueBtn">' + (row.blklst_cancel_yn === 'Y' ? '등록' : '해제') + '</a>'
       		}, 			
			{label: '수정',        name:'update_btn',		   align: 'center', width: 50, fixed: true, sortable: false, 
       			formatter: (c, o, row) => '<a href="javascript:fnBlackInfo(\''+ row.blklst_seq + '\');" class="edt_icon"></a>'
       		} 
        ], false, false, fnSearch);
		
		// 고객 검색 JqGrid 정의
		EgovJqGridApi.pagingGrid('popGrid', [
			{label: '아이디',	  	name:'user_id',	   align:'center', width:'150px', sortable: false, key: true},
			{label: '이름',	  	name:'user_nm',	   align:'center', width:'150px', sortable: false},
			{label: '전화번호', 	name:'user_phone', align:'center', width:'150px', sortable: false}
		], 'popPager', false);
		
        // BlackList Tab Event
		$('.blacklist.tabs>.tab').on('click', function(){
		  	var tabIdx = $(this).index();
		  	var $tabBtn = $('.blacklist.tabs>.tab');
		  	var $tbody = $('.blacklist.main_table>tbody');
		  	$tabBtn.removeClass('active');
		  	$(this).addClass('active');
		  	$tbody.removeClass('active');
		  	$tbody.eq(tabIdx).addClass('active');
		});
	});
    
	// 메인 목록 검색
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val(),
			searchCondition : $("#searchCondition").val(),
			searchBlklstDvsn : $("#searchBlklstDvsn").val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/rsv/blackListAjax.do', params, fnSearch);
		
		let col = $('#searchBlklstDvsn').val() === 'BLKLST_DVSN_3' ? 'hideCol' : 'showCol';
		$(MainGridSelector).jqGrid(col, ['user_noshow_cnt', 'user_noshow_last_dt', 'update_btn']);
		$(MainGridSelector).setGridWidth($(MainGridSelector).closest('div.boardlist').width() , true);
	}
	
	// 메인 상세 팝업 정의
	function fnBlackInfo(rowId) {
		let $popup = $('[data-popup=rsv_blacklist_add]');
		let $form = $popup.find('form:first');
		if (rowId === undefined || rowId === null) {
			$popup.find('h2:first').text('출입통제 등록');
			$popup.find('button.blueBtn').off('click').click(fnBlackInsert);
			$form.find(':text').val('');
			$form.find('textarea[name=blklstReason]').val('');
            $form.find('select[name=userSearchCondition] option:first').prop('selected', true);
            $form.find('select[name=blklstDvsn] option:first').prop('selected', true);
		} else {
			let rowData = EgovJqGridApi.getMainGridRowData(rowId);
			$popup.find('h2:first').text('관리자 수정');
			$popup.find('button.blueBtn').off('click').click(fnBlackUpdate);
			$form.find(':hidden[name=mode]').val('Edt');
			$form.find(':hidden[name=blklstSeq]').val(rowData.blklst_seq);
			$form.find(':hidden[name=blklstCancelYn]').val(rowData.blklst_cancel_yn);
			$form.find(':text').val('');
			$form.find('textarea[name=blklstReason]').val(rowData.blklst_reason);
			$form.find('select[name=userSearchCondition] option:first').prop('selected', true);
			$form.find('select[name=blklstDvsn]').val(rowData.blklst_dvsn);
			$form.find(':text[name=userId]').val(rowData.user_id);
			$form.find(':text[name=userNm]').val(rowData.user_nm);
			$form.find('text[name=userClphn]').val(rowData.user_phone);
		}
		$popup.bPopup();
	}

	// 출입통제 정보 등록
	function fnBlackInsert() {
		let $popup = $('[data-popup=rsv_blacklist_add]');
		if ($popup.find(':text[name=userId]').val() === '') {
			toastr.warning('출입통제 대상을 선택해 주세요.');
			return;
		}
		bPopupConfirm('출입통제 등록', '등록 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/rsv/blackUserUpdate.do',
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
	
	// 출입통제 정보 수정
	function fnBlackUpdate() {
		let $popup = $('[data-popup=rsv_blacklist_add]');
		bPopupConfirm('출입통제 수정', '<b>'+ $popup.find(':text[name=userId]').text() +'</b> 수정 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/rsv/blackUserUpdate.do',
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
	
	// 출입통제 정보 삭제
	function fnBlackDelete() {
		let $popup = $('[data-popup=rsv_blacklist_add]');
		let rowId = EgovJqGridApi.getMainGridSingleSelectionId();
		let rowData = EgovJqGridApi.getMainGridRowData(rowId);
		
		if (rowId === null) {
			toastr.warning('목록을 선택해 주세요.');
			return;
		}
		bPopupConfirm('출입통제 고객정보 삭제', rowData.blklst_dvsn_txt + ' <b>' + rowData.user_id +'</b> 를(을) 삭제 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/rsv/blackUserDelete.do', {
					blklstSeq : rowId
				},
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
	
	// 출입통제 유형 변경
	function fnChangeBlackDvsn(el) {
		$('#searchKeyword').val('');
		$('.ui-pg-selbox option:selected').val(10);
		$('#searchBlklstDvsn').val($(el).attr('id'));
		fnSearch();
	}
	
	// 출입통제상태 변경
	function fnChangeBlackState(rowId) {
		let resultTxt;
		let rowData = EgovJqGridApi.getMainGridRowData(rowId);
		
		if(rowData.blklst_cancel_yn === 'Y') {
			resultTxt = '출입통제가 정상적으로 등록되었습니다.';
			rowData.blklst_cancel_yn = 'N';
		} else {
			resultTxt = '출입통제가 정상적으로 해제 되었습니다.';
			rowData.blklst_cancel_yn = 'Y';
		}
		
		let params = {
			mode : 'Edt', 
			blklstSeq : rowData.blklst_seq, 
			blklstCancelYn : rowData.blklst_cancel_yn, 
			blklstDvsn : rowData.blklst_dvsn, 
			userId : rowData.user_id 
		};
		
		EgovIndexApi.apiExecuteJson(
			'POST',
			'/backoffice/rsv/blackUserUpdate.do',
			params,
			null,
			function(json) {
				if(json.status === 'SUCCESS') {
		    		toastr.success(resultTxt);
		    		fnSearch();
				} else {
					toastr.error(json.meesage);
				}
			},
			function(json) {
				toastr.error(json.message);
			} 		
		);
	}
	
	// 출입통제대상(고객) 검색 팝업 호출
	function fnUserInfoPopup() {
		$('#pSearchKeyword').val(
			$('[data-popup=rsv_blacklist_add] :text[name=userSearchKeyword]').val()
		);
		fnUserInfoSearch(1);
		setTimeout(function() {
			$('[data-popup=rsv_user_search]').bPopup();	
		}, 100);
	}
	
	// 출입통제대상(고객) 검색
	function fnUserInfoSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: '5',
			searchKeyword: $('#pSearchKeyword').val(),
			searchCondition : $('#searchUserGubun').val(),
			mode: 'list'
		};
		EgovJqGridApi.pagingGridAjax('popGrid', '/backoffice/cus/userListInfoAjax.do', params, fnUserInfoSearch);
	}
	
	// 검색된 출입통제대상(고객) 정보 선택
	function fnInUserSearchInfo() {
		let rowId = EgovJqGridApi.getGridSelectionId('popGrid');
		let rowData = EgovJqGridApi.getGridRowData('popGrid', rowId);
		let $popup = $('[data-popup=rsv_blacklist_add]');
		$popup.find(':text[name=userId]').val(rowId);
		$popup.find(':text[name=userNm]').val(rowData.user_nm);
		$popup.find(':text[name=userClphn]').val(rowData.user_phone);
		$('[data-popup=rsv_user_search]').bPopup().close();
	}
</script>