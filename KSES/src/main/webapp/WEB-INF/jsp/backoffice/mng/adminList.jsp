<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!-- JQuery Grid -->
<link rel="stylesheet" href="/resources/jqgrid/src/css/ui.jqgrid.css">
<script type="text/javascript" src="/resources/jqgrid/src/i18n/grid.locale-kr.js"></script>
<script type="text/javascript" src="/resources/jqgrid/js/jquery.jqGrid.min.js"></script>
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
		<li>인사 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">관리자 관리</li>
	</ol>
</div>
<h2 class="title">관리자 관리</h2>
<div class="clear"></div>
<div class="dashboard">
	<div class="boardlist">
		<div class="whiteBox searchBox">
			<div class="top">
				<p>권한</p>
				<select id="searchAuthorCd">
					<option value="">권한 선택</option>
					<c:forEach var="item" items="${authorCd}">
						<option value="${item.author_code}"><c:out value="${item.author_nm}"/></option>
					</c:forEach>
				</select>
				<p>부서</p>
				<select id="searchDeptCd">
					<option value="">부서 선택</option>
					<c:forEach var="item" items="${dept}">
						<option value="${item.deptCd}"><c:out value="${item.deptNm}"/></option>
					</c:forEach>
				</select>
				<p>검색어</p>
				<select id="searchCondition">
					<option value="ALL">선택</option>
					<option value="ADMIN_ID">아이디</option>
					<option value="b.EMP_NO">이름</option>
				</select> 
				<input type="text" id="searchKeyword" placeholder="검색어를 입력하세요.">
			</div>
			<div class="inlineBtn">
				<a href="javascript:fnSearch(1);" class="grayBtn">검색</a>
			</div>
		</div>
		<div class="left_box mng_countInfo">
			<p>총 : <span id="sp_totcnt"></span>건</p>
		</div>
		<div class="right_box">
			<a href="javascript:fnAdminInfo();" class="blueBtn">관리자 등록</a>
			<a href="javascript:fnAdminDelete();" class="grayBtn">관리자 삭제</a>
		</div>
		<div class="clear"></div>
		<div class="whiteBox">
			<table id="mainGrid"></table>
			<div id="pager"></div>
		</div>
	</div>
</div>
<!-- contents//-->
<!-- //popup -->
<!-- // 관리자 등록 팝업 -->
<div data-popup="mng_admin_add" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
		<h2 class="pop_tit" id="h2_txt">관리자 등록</h2>
		<div class="pop_wrap">
			<form>
			<input type="hidden" name="mode" value="Ins">
			<table class="detail_table">
				<tbody>
					<tr>
						<th>사번</th>
						<td>
							<input type="hidden" name="adminId">
							<input type="text" name="empNo">&nbsp;
							<a href="javascript:fnEmpInfoPopup();" class="grayBtn">검색</a>
						</td>
						<th>이름</th>
						<td><span id="spEmpNm"></span></td>
					</tr>
					<tr>
						<th>부서</th>
						<td><span id="spEmpDeptNm"></span></td>
						<th>연락처</th>
						<td><span id="spEmpClphn"></span></td>
					</tr>
					<tr>
						<th>관리등급</th>
						<td>
							<select name="authorCd">
								<option value="">권한 선택</option>
								<c:forEach var="item" items="${authorCd}">
									<option value="${item.author_code}"><c:out value="${item.author_nm}"/></option>
								</c:forEach>
							</select>
						</td>
						<th>지점</th>
						<td>
							<select name="centerCd" style="display:none">
								<option value="">지점 선택</option>
								<c:forEach var="item" items="${centerCd}">
									<option value="${item.center_cd}"><c:out value="${item.center_nm}"/></option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th>이메일</th>
						<td><span id="spEmpEmail"></span></td>
						<th>사용여부</th>
						<td>
							<input type="radio" name="useYn" value="Y">사용</input>
							<input type="radio" name="useYn" value="N">사용안함</input>
						</td>
					</tr>
				</tbody>
			</table>
			</form>
		</div>
		<div class="right_box">
			<button type="button" class="blueBtn">저장</button>
			<button type="button" class="grayBtn b-close">닫기</button>
		</div>
		<div class="clear"></div>
	</div>
</div>
<!-- 관리자 등록 팝업 // -->
<!-- // 직원 검색 팝업 -->
<div data-popup="mng_emp_search" class="popup">
	<div class="pop_con">
		<h2 class="pop_tit">직원 검색</h2>
		<div class="pop_wrap">
			<fieldset class="whiteBox searchBox">
				<div class="top" style="padding:0;border-bottom:none;">
					<select id="searchEmpGubun" style="width:100px;">
						<option value="">선택</option>
						<option value="emp_nm">이름</option>
						<option value="emp_no">사번</option>
					</select>
					<input type="text" id="pSearchKeyword" placeholder="검색어를 입력하세요.">
					<a href="javascript:fnEmpInfoSearch(1);" class="grayBtn">검색</a>
				</div>
			</fieldset>
			<div style="width:570px;">
				<table id="popGrid"></table>
				<div id="popPager"></div>
			</div>
		</div>
		<div class="right_box">
	    	<button type="button" onclick="fnAdminIdCheck();" class="blueBtn">선택</button>
	    	<button type="button" class="grayBtn b-close">취소</button>
		</div>
	</div>
</div>
<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		// 메인 JqGrid 정의
		EgovJqGridApi.mainGrid([
			{ label: '아이디', name: 'admin_id', align:'center', key: true },
			{ label: '사번', name: 'emp_no', hidden: true },
			{ label: '이름', name: 'emp_nm', align:'center' },
			{ label: '권한', name: 'author_nm', align: 'center' },
			{ label: '권한코드', name: 'author_cd', hidden: true },
			{ label: '부서', name: 'dept_nm', align: 'center' },
			{ label: '연락처', name: 'emp_clphn', align:'center' },
			{ label: '이메일', name:'emp_email', align:'left' },
			{ label: '잠김여부', name:'admin_lockyn', align:'center' },
			{ label: '사용유무', name:'use_yn', align:'center' },
			{ label: '지점코드', name:'center_cd', hidden: true },
			{ label: '지점', name:'admin_dvsn', align:'center' },
			{ label: '최종수정일', name:'last_updt_dtm', align:'center', formatter: 'date' },
			{ label: '수정', align:'center', width: 50, fixed: true, formatter: (c, o, row) =>
	        	'<a href="javascript:fnAdminInfo(\''+ row.admin_id +'\');" class="edt_icon"></a>'
	        }
		], true, false, fnSearch);
		// 직원 검색 JqGrid 정의
		EgovJqGridApi.popGrid('popGrid', [
			{ label: '사번', name: 'emp_no', align: 'center', sortable: false, key: true },
			{ label: '이름', name: 'emp_nm', align: 'center', sortable: false },
			{ label: '부서', name: 'dept_nm', align: 'center', sortable: false },
			{ label: '전화번호', name: 'emp_clphn', hidden: true },
			{ label: '이메일', name: 'emp_email', hidden: true }
		], 'popPager');
		// 관리자 상세 화면의 권한 Select Change Event 정의
		$('[data-popup=mng_admin_add] select[name=authorCd]').change(function(e) {
			let $center = $('[data-popup=mng_admin_add] select[name=centerCd]');
			switch ($(this).val()) {
				case '':
				case 'ROLE_ADMIN':
				case 'ROLE_SYSTEM':
					$center.hide();
					break;
				default:
					$center.show();
			}
		});
	});
	// 메인 목록 검색
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val(),
			searchAuthorCd: $('#searchAuthorCd').val(),
			searchDeptCd: $('#searchDeptCd').val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/mng/adminListAjax.do', params, fnSearch);
	}
	// 메인 상세 팝업 정의
	function fnAdminInfo(rowId) {
		let $popup = $('[data-popup=mng_admin_add]');
		let $form = $popup.find('form:first');
		if (rowId === undefined || rowId === null) {
			$popup.find('h2:first').text('관리자 등록');
			$popup.find('button.blueBtn').off('click').click(fnAdminInsert);
			$popup.find('a.grayBtn').show();
			$form.find(':hidden[name=mode]').val('Ins');
			$form.find(':hidden[name=adminId]').val('');
			$form.find(':text[name=empNo]').removeAttr('readonly');
			$form.find(':text,:password,select').val('');
			$form.find('select[name=authorCd]').trigger('change');
			$form.find(':radio[name=useYn]:first').prop('checked', true);
			$form.find('#spEmpNm').text('');
			$form.find('#spEmpDeptNm').text('');
			$form.find('#spEmpClphn').text('');
			$form.find('#spEmpEmail').text('');
		}
		else {
			let rowData = $('#mainGrid').jqGrid('getRowData', rowId);
			$popup.find('h2:first').text('관리자 수정');
			$popup.find('button.blueBtn').off('click').click(fnAdminUpdate);
			$popup.find('a.grayBtn').hide();
			$form.find(':hidden[name=mode]').val('Edt');
			$form.find(':hidden[name=adminId]').val(rowData.admin_id);
			$form.find(':text[name=empNo]').prop('readonly', true).val(rowData.emp_no);
			$form.find('select[name=authorCd]').val(rowData.author_cd).trigger('change');
			$form.find('select[name=centerCd]').val(rowData.center_cd);
			$form.find(':radio[name=useYn][value='+ rowData.use_yn +']').prop('checked', true);
			$form.find('#spEmpNm').text(rowData.emp_nm);
			$form.find('#spEmpDeptNm').text(rowData.dept_nm);
			$form.find('#spEmpClphn').text(rowData.emp_clphn);
			$form.find('#spEmpEmail').text(rowData.emp_email);
		}
		$popup.bPopup();
	}
	// 관리자 등록
	function fnAdminInsert() {
		let $popup = $('[data-popup=mng_admin_add]');
		let $form = $popup.find('form:first');
		if ($form.find(':text[name=empNo]').val() === '') {
			toastr.warning('사번을 입력해 주세요.');
			return;
		}
		if ($form.find(':hidden[name=adminId]').val() === '') {
			toastr.warning('중복 체크가 안되었습니다. [검색]으로 직원 검색하세요.');
			return;
		}
		if ($form.find('select[name=authorCd]').val() === '') {
			toastr.warning('권한을 선택해 주세요.');
			return;
		}
		bPopupConfirm('관리자 등록', '등록 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/mng/adminUpdate.do', 
				$form.serializeObject(),
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
	// 관리자 수정
	function fnAdminUpdate() {
		let $popup = $('[data-popup=mng_admin_add]');
		let $form = $popup.find('form:first');
		if ($form.find('select[name=authorCd]').val() === '') {
			toastr.warning('권한을 선택해 주세요.');
			return;
		}
		bPopupConfirm('관리자 수정', '<b>'+ $form.find('#spEmpNm').text() +'</b>수정 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/mng/adminUpdate.do', 
				$form.serializeObject(),
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
	// 관리자 삭제
	function fnAdminDelete() {
		let rowIds = $('#mainGrid').jqGrid('getGridParam', 'selarrrow');
		if (rowIds.length === 0) {
			toastr.warning('목록을 선택해 주세요.');
			return false;
		}
		bPopupConfirm('관리자 삭제', '삭제 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/mng/adminDelete.do', {
					adminNoDel: rowIds.join(',')
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
	// 직원 검색 팝업 호출
	function fnEmpInfoPopup() {
		$('#pSearchKeyword').val(
			$('[data-popup=mng_admin_add] :text[name=empNo]').val()
		);
		fnEmpInfoSearch(1);
		setTimeout(function() {
			$('[data-popup=mng_emp_search]').bPopup();	
		}, 100);
	}
	// 직원 검색
	function fnEmpInfoSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: '5',
			searchKeyword: $('#pSearchKeyword').val()
		};
		EgovJqGridApi.popGridAjax('popGrid', '/backoffice/mng/empListAjax.do', params, fnEmpInfoSearch);
	}
	// 관리자 등록 위한 직원 중복 체크
	function fnAdminIdCheck() {
		let rowId = $('#popGrid').jqGrid('getGridParam', 'selrow');
		if (rowId === null) {
			toastr.warning('목록을 선택해주세요.');
			return;
		}
		EgovIndexApi.apiExecuteJson(
			'GET',
			'/backoffice/mng/adminIdCheck.do',{
				adminId: rowId	
			},
			null,
			function(json) {
				toastr.info(json.message);
				let rowData = $('#popGrid').jqGrid('getRowData', rowId);
				let $popup = $('[data-popup=mng_admin_add]');
				$popup.find(':hidden[name=adminId]').val(rowId);
				$popup.find(':text[name=empNo]').val(rowId);
				$popup.find('#spEmpNm').text(rowData.emp_nm);
				$popup.find('#spEmpDeptNm').text(rowData.dept_nm);
				$popup.find('#spEmpClphn').text(rowData.emp_clphn);
				$popup.find('#spEmpEmail').text(rowData.emp_email);
				$('[data-popup=mng_emp_search]').bPopup().close();
			},
			function(json) {
				toastr.warning(json.message);
			}
		);
	}
</script>