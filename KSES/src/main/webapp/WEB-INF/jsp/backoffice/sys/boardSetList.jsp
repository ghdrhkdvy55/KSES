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
    	<li>시스템 관리&nbsp;&gt;&nbsp;</li>
    	<li class="active">게시판 등록 관리</li>
  	</ol>
</div>
<h2 class="title">게시판 등록 관리</h2>
<div class="clear"></div>
<div class="dashboard">
    <div class="boardlist">
        <div class="left_box mng_countInfo">
            <p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
        
        <div class="right_box">
        	<a href="#" onClick="javascript:fnBoardInfo();"  class="blueBtn">게시판 등록</a> 
        	<a href="#" onClick="fnBoardDel();"  class="grayBtn">삭제</a>
       	</div>
    
        <div class="clear"></div>
        <div class="whiteBox">
            <table id="mainGrid"></table>
            <div id="pager" class="scroll" style="text-align:center;"></div>  
        </div>
    </div>
</div>
<!-- contents//-->

<!-- // 게시판 추가 팝업 -->
<div data-popup="board_add" id="board_add" class="popup">
	<div class="pop_con">
      	<a class="button b-close">X</a>
      	<h2 class="pop_tit">게시판 추가</h2>
      	<div class="pop_wrap">
      		<form>
	      		<input type="hidden" id="mode" name="mode" value="Ins">
	          	<table class="detail_table">
	              	<tbody>
	                  	<tr>
	                      	<th>게시판 아이디</th>
	                      	<td>
	                          	<input type="text" id="boardCd" name="boardCd" >
	                          	<span id="sp_Unqi">
	                          		<a href="javascript:fnIdCheck()" class="blueBtn">중복확인</a>
	                          		<input type="hidden" id="idCheck">
	                          	</span>
	                      	</td>
	                      	<th>게시판 이름</th>
	                      	<td><input type="text" id="boardTitle" name="boardTitle"></td>
	                  	</tr>
	                  	<tr>
	                    	<th>게시판 구분</th>
	                    	<td>
	                      		<select name="boardDvsn" id="boardDvsn">
	                        		<option value="">게시물 구분</option>
			                		<c:forEach items="${boardGubun}" var="boardGubun">
			                     		<option value="${boardGubun.code}">${boardGubun.codenm}</option>
						    		</c:forEach>
	                      		</select>
	                    	</td>
	                    	<th>권한 설정</th>
	                    	<td>
	                      		<select name="boardAuthor" id="boardAuthor" onChange="javascript:fnCenterCheck(this);">
	                         		<option value="">권한 설정</option>
	                         		<c:forEach items="${authorInfo}" var="authorInfo">
			                     		<option value="${authorInfo.author_code}">${authorInfo.author_nm}</option>
						    		</c:forEach>
	                      		</select> 
	                    	</td>
	                  	</tr>
	                  	<tr>
	                    	<th>지점 선택</th>
	                    	<td><span id="sp_boardCenter"></span></td>
	                    	<th>사용 유무</th>
	                    	<td>
	                      		<label for="useAt_Y"><input name="useYn" type="radio" id="useAt_Y" value="Y"/>사용</label>
	                      		<label for="useAt_N"><input name="useYn" type="radio" id="useAt_N" value="N"/>사용 안함</label>
	                       </td>
	                  	</tr>
						<tr>
	                    	<th>업로드 구분</th>
	                    	<td>
	                      		<label for="boardFileUploadYn_y"><input type="radio" name="boardFileUploadYn" id="boardFileUploadYn_y" value="Y">Y</label>
	                      		<label for="boardFileUploadYn_n"><input type="radio" name="boardFileUploadYn" id="boardFileUploadYn_n" value="N">N</label>
	                    	</td>
							<th>댓글 여부</th>
	                    	<td>
	                      		<label for="boardCmntUse_y"><input type="radio" name="boardCmntUse" id="boardCmntUse_y" value="Y">Y</label>
	                      		<label for="boardCmntUse_n"><input type="radio" name="boardCmntUse" id="boardCmntUse_n" value="N">N</label>
	                    	</td>
	                  	</tr>
	                  	<tr>
	                    	<th>페이지 사이즈</th>
	                    	<td>
	                       		<select name="boardSize" id="boardSize">
	                         	<option value="">페이지 사이즈</option>
	                         		<c:forEach items="${boardSize}" var="boardSize">
			                     	<option value="${boardSize.code}">${boardSize.codenm}</option>
						    		</c:forEach>
	                      		</select> 
	                    	</td>
	                    	<th>공지 여부</th>
							<td>
								<select name="boardNoticeDvsn" id="boardNoticeDvsn">
									<option value="">공지구분</option>
									<c:forEach items="${boardNotice}" var="boardNotice">
										<option value="${boardNotice.code}">${boardNotice.codenm}</option>
									</c:forEach>
								</select> 
							</td>
	                  	</tr>
	              	</tbody>
	          	</table>
          	</form>
      	</div>
       <popup-right-button />
  	</div>
</div>
<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {

		// 메인 JqGrid 정의
		EgovJqGridApi.mainGrid([
			{ label:'게시 아이디'	, name:'board_cd'				, align:'center', key: true},
			{ label:'게시판 타이틀'	, name:'board_title'			, align:'left'},
			{ label:'권한 설정'	, name:'board_author_nm'		, align:'center'},
            { label:'관련지점'		, name:'board_center_id'		, align:'center'},
			{ label:'파일업로드'	, name:'board_file_upload_yn'	, align:'center', formatter: (c, o, row) =>
				row.board_file_upload_yn == "Y" ? "사용" : "사용 안함"
			},
            { label:'댓글사용'		, name:'board_cmnt_use'			, align:'center', formatter: (c, o, row) =>
				row.board_cmnt_use == "Y" ? "사용" : "사용 안함"
            },
	        { label:'사용유무'		, name:'use_yn'					, align:'center', formatter: (c, o, row) =>
				row.use_yn == "Y" ? "사용" : "사용 안함"
	        },
			{ label:'페이지사이즈'	, name:'board_size'				, align:'right'},
			{ label:'최종수정일자'	, name:'last_updt_dtm'			, align:'center', sortable: 'date', formatter: "date", formatoptions: { newformat: "Y-m-d"}},
			{ label:'수정자'		, name:'last_updusr_id'			, align:'center', fixed:true},
			{ label:'수정', align:'center', width: 50, fixed: true, formatter: (c, o, row) =>
        		'<a href="javascript:fnBoardInfo(\''+ row.board_cd +'\');" class="edt_icon"></a>'
        	},
        	{ name:'board_author'          , hidden:true},
        	{ name:'board_dvsn_code'       , hidden:true},
        	{ name:'board_center_id_code'  , hidden:true},
        	{ name:'board_notice_dvsn_code', hidden:true},
        	{ name:'board_size_code'       , hidden:true}
		], true, false, fnSearch);
		
	});
   	
	// 메인 목록 검색
	function fnSearch(pageNo) {

		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $("#searchKeyword").val()

		};

		EgovJqGridApi.mainGridAjax('/backoffice/sys/boardSetListAjax.do', params, fnSearch);

	}

	// 메인 상세 팝업 정의
	function fnBoardInfo(rowId) {

		let $popup = $('[data-popup=board_add]');
		let $form = $popup.find('form:first');

		if (rowId === undefined || rowId === null) {
			$popup.find('h2:first').text('게시판 등록');
			$popup.find('#sp_Unqi').show();
			$popup.find('button.blueBtn').off('click').click(fnBoardInsert);
			$form.find(':hidden[name=mode]').val('Ins');
			
			$form.find("#boardCd").val('').prop('readonly', false);
			$form.find("#boardTitle").val('');
			$form.find("#boardDvsn").val('');
			$form.find("#boardAuthor").val('');
			$form.find("#boardSize").val('');
        	$form.find("#boardNoticeDvsn").val('');
        	$form.find("#boardAuthor").val('');
        	$form.find("input:radio[name='useYn'][value='Y']").prop('checked', true);
        	$form.find("input:radio[name='boardFileUploadYn'][value='N']").prop('checked', true);
        	$form.find("input:radio[name='boardCmntUse'][value='N']").prop('checked', true);
        	$form.find("#sp_Unqi").show();
        	$form.find("#btnUpdate").text("등록");
        	
        	$form.find("#sp_boardCenter").empty();	
		}
		else {
			let rowData = EgovJqGridApi.getMainGridRowData(rowId);

			var useYn = rowData.use_yn === '사용' ? 'Y' : 'N';
			var boardFileUploadYn = rowData.board_file_upload_yn === '사용' ? 'Y' : 'N';
			var boardCmntUse = rowData.board_cmnt_use === '사용' ? 'Y' : 'N';
			
			$popup.find('h2:first').text('게시판 수정');
			$popup.find('#sp_Unqi').hide();
			$popup.find('button.blueBtn').off('click').click(fnBoardUpdate);
			$form.find(':hidden[name=mode]').val('Edt');
			
			$form.find("#boardCd").val(rowId).prop('readonly', true);
			$form.find("#boardTitle").val(rowData.board_title);
			$form.find("#boardDvsn").val(rowData.board_dvsn_code);
			$form.find("#boardAuthor").val(rowData.board_author);  
			$form.find("#boardSize").val(rowData.board_size_code);	
			$form.find("#boardNoticeDvsn").val(rowData.board_notice_dvsn_code);
			$form.find("input:radio[name='useYn'][value='" + useYn + "']").prop('checked', true);
			$form.find("input:radio[name='boardFileUploadYn'][value='" + boardFileUploadYn + "']").prop('checked', true);
			$form.find("input:radio[name='boardCmntUse'][value='" + boardCmntUse + "']").prop('checked', true);
			$form.find("#btnUpdate").text("수정");

			if (rowData.board_center_id != ""){

				EgovIndexApi.apiExecuteJson(
					'GET',
					'/backoffice/bld/centerCombo.do', null, null,
					function(json) {
						// back_common.js 에 정의 되어 있음 확인 및 수정 필요.
						fn_checkboxListJson("sp_boardCenter", json.resultlist, rowData.board_center_id_code, "boardCenterId");
					},
					null
				);
	       	}
		}

		$popup.bPopup();

	}

	// 게시판 등록
	function fnBoardInsert() {
		
		let $popup = $('[data-popup=board_add]');

		if($('#boardCd').val() === '') {
			toastr.warning('게시판아이디를 입력해 주세요.');
			return;
		}

		if ($(':hidden#idCheck').val() !== 'Y') {
			toastr.warning('중복체크가 안되었습니다.');
			return;	
		}

		if(fnValidate() != true) return false; // 입력 폼 유효성 검사

		var boardCenterId = fnBoardCenterIdArr(); // 지점 파라미터 생성.
	
		var param = $popup.find('form:first').serializeObject();

		param.boardCenterId = boardCenterId;

		bPopupConfirm('게시판 등록', '등록 하시겠습니까?', function() {
			
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/sys/boardSetUpdate.do',
				param,
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

	// 게시판 수정
	function fnBoardUpdate() {
		
		let $popup = $('[data-popup=board_add]');
		
		if(fnValidate() != true) return false; // 입력 폼 유효성 검사

		var boardCenterId = fnBoardCenterIdArr(); // 지점 파라미터 생성.

		var param = $popup.find('form:first').serializeObject();

		param.boardCenterId = boardCenterId;

		bPopupConfirm('게시판 코드 수정', '<b>'+ $('#boardCd').val() +'</b> 수정 하시겠습니까?', function() {

			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/sys/boardSetUpdate.do',
				param,
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

	// 게시판 삭제 호출
	function fnBoardDel() {
		
		var checkedRow = EgovJqGridApi.getMainGridMutipleSelectionIds();

		if (checkedRow.length > 0){
			bPopupConfirm('게시판 삭제', '삭제 하시겠습니까?', function() {

				EgovIndexApi.apiExecuteJson(
					'GET',
					'/backoffice/sys/boardSetDelete.do',
					{delCd: checkedRow.join(",") },
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

		} else {
			toastr.warning('체크된 값이 없습니다.');
		}
	}
	
	// 게시판 아이디 중복 체크
	function fnIdCheck() {

		let $popup = $('[data-popup=board_add]');
        let rowId = $popup.find(':text[name=boardCd]').val();

        if (rowId === '') {
			toastr.warning('게시판 아이디를 입력해 주세요.');
			return;
		}

		EgovIndexApi.apiExecuteJson(
			'GET',
			'/backoffice/sys/boadCdCheck.do', {
				boardCd: rowId
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

	// 게시판 등록 팝업 권한 설정 콤보박스 선택 변경시.
	function fnCenterCheck(obj) {
	 	//체크 박스 보여 주기 
	 	if ($(obj).val() !== "ROLE_SYSTEM" && $(obj).val() !== "ROLE_ADMIN" && $(obj).val() !== ""){
		 	EgovIndexApi.apiExecuteJson(
					'GET',
					'/backoffice/bld/centerCombo.do', null, null,
					function(json) {
						// back_common.js 에 정의 되어 있음 확인 및 수정 필요.
						fn_checkboxListJson("sp_boardCenter", json.resultlist, "", "boardCenterId");
					},
					null
				);

	 	} else {
		 	$("#sp_boardCenter").empty();
	 	}	
 	}

	// 입력 폼 유효성 검사
	function fnValidate() {
		
		if ($('#boardTitle').val() === '') {
			toastr.warning('게시판명을 입력해 주세요.');
			return;	
		}
		
		if ($('#boardSize option:selected').val() === '') {
			toastr.warning('게시판 페이지 수를 선택해 주세요.');
			return;	
		}
		
		if ($('#boardAuthor option:selected').val() === '') {
			toastr.warning('권한설정을 선택해 주세요.');
			return;	
		}
		
		if (($("#boardAuthor option:selected").val() !== "ROLE_SYSTEM" && $("#boardAuthor option:selected").val() !== "ROLE_ADMIN" 
				&& $("#boardAuthor option:selected").val() !== "")
				&& $("input:checkbox[name='boardCenterId']:checked").length < 1){ 
			toastr.warning('지점을 1개 이상 선택해 주세요.');
			return;
		}

		return true;
	}

	// 지점 파라미터 생성.
	function fnBoardCenterIdArr() {

		var boardCenterIdArr = new Array();

		$("input:checkbox[name='boardCenterId']:checked").each(function(){
			boardCenterIdArr.push($(this).val());
		});

		return boardCenterIdArr.join(",");
	}
</script>