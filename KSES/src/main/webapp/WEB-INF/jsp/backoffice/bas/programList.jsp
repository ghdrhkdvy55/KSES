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
<!-- Xlsx -->
<script type="text/javascript" src="/resources/js/xlsx.full.min.js"></script>
<!-- FileSaver -->
<script src="/resources/js/FileSaver.min.js"></script>
<!-- //contents -->
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>기초 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">프로그램 관리</li>
	</ol>
</div>
<h2 class="title">프로그램 관리</h2>
<div class="clear"></div>
<div class="dashboard">
    <div class="boardlist">
    	<div class="whiteBox searchBox">
            <div class="top">                    
                <p>검색어</p>
                <input type="text" id="searchKeyword" placeholder="검색어를 입력하세요." autocomplete="off">
            </div>
            <div class="inlineBtn">
                <a href="javascript:fnSearch(1);" class="grayBtn">검색</a>
            </div>
        </div>
        <div class="left_box mng_countInfo">
            <p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
        <div class="right_box">
			<a href="javascript:fnExcelDownload();" class="blueBtn">엑셀 다운로드</a> 
        	<a href="javascript:fnProgramInfo();" class="blueBtn">프로그램 등록</a>
        	<a href="javascript:fnProgramDelete();" class="grayBtn">프로그램 삭제</a>            	
        </div>
         
        <div class="clear"></div>
        <div class="whiteBox">
            <table id="mainGrid"></table>
            <div id="pager"></div>  
        </div>
    </div>
</div>
<!-- contents// -->
<!-- //popup -->
<!-- 프로그램 추가 팝업-->
<div data-popup="bas_program_add" class="popup m_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">프로그램 등록</h2>
        <div class="pop_wrap">
        	<form>
        	<input type="hidden" name="mode" value="Ins">
            <table class="detail_table">
				<tbody>
					<tr>
						<th>파일명</th>
						<td>
						    <input type="text" name="progrmFileNm">
						    <span id="sp_Unqi">
                            	<a href="javascript:fnIdCheck();" class="blueBtn">중복확인</a>
                            	<input type="hidden" id="idCheck" value="N">
                            </span>
						</td>
					</tr>
					<tr>
						<th>저정경로</th>
						<td>
						    <input type="text" name="progrmStrePath">
						</td>
					</tr>
					<tr>
						<th>한글명</th>
						<td>
						    <input type="text" name="progrmKoreannm">
						</td>
					</tr>
					<tr>
						<th>URL</th>
						<td>
						    <input type="text" name="url">
						</td>
					</tr>
					<tr>
						<th>설명</th>
						<td>
						    <textarea name="progrmDc" cols="25" rows="5"></textarea>
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
			{ label: '파일명', name: 'progrm_file_nm', align: 'left', fixed: true, key: true },
			{ label: '한글명',  name: 'progrm_koreannm', align: 'left', fixed: true },
			{ label: '저장경로', name: 'progrm_stre_path', hidden: true },
			{ label: 'URL', name: 'url', align: 'left' },
			{ label: '설명', name: 'progrm_dc', align: 'left', sortable: false },
			{ label: '수정', align:'center', width: 50, fixed: true, formatter: (c, o, row) =>
	        	'<a href="javascript:fnProgramInfo(\''+ row.progrm_file_nm +'\');" class="edt_icon"></a>'
	        }
		], false, false, fnSearch);
	});
	// 메인 목록 검색
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/bas/progrmListAjax.do', params, fnSearch);
	}
	// 프로그램 상세 팝업 정의
	function fnProgramInfo(rowId) {
		let $popup = $('[data-popup=bas_program_add]');
		let $form = $popup.find('form:first');
		if (rowId === undefined || rowId === null) {
			$popup.find('h2:first').text('프로그램 등록');
			$popup.find('span#sp_Unqi').show();
			$popup.find('button.blueBtn').off('click').click(fnProgramInsert);
			$form.find(':hidden[name=mode]').val('Ins');
			$form.find(':text').val('');
			$form.find('textarea[name=progrmDc]').val('');
			$form.find(':text[name=progrmFileNm]').removeAttr('readonly');
		}
		else {
			let rowData = $('#mainGrid').jqGrid('getRowData', rowId);
			$popup.find('h2:first').text('프로그램 수정');
			$popup.find('span#sp_Unqi').hide();
			$popup.find('button.blueBtn').off('click').click(fnProgramUpdate);
			$form.find(':hidden[name=mode]').val('Edt');
			$form.find(':text[name=progrmFileNm]').prop('readonly', true).val(rowData.progrm_file_nm);
			$form.find(':text[name=progrmStrePath]').val(rowData.progrm_stre_path);
			$form.find(':text[name=progrmKoreannm]').val(rowData.progrm_koreannm);
			$form.find(':text[name=url]').val(rowData.url);
			$form.find('textarea[name=progrmDc]').val(rowData.progrm_dc);
		}
		$popup.bPopup();
	}
	// 프로그램명 중복 체크
	function fnIdCheck() {
		let $popup = $('[data-popup=bas_program_add]');
		if ($popup.find(':text[name=progrmFileNm]').val() === '') {
			toastr.warning('프로그램 파일명을 입력해주세요.');
			return;
		}
		EgovIndexApi.apiExecuteJson(
			'GET',
			'/backoffice/bas/programIDCheck.do', {
				progrmFileNm: $popup.find(':text[name=progrmFileNm]').val()
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
	// 프로그램 등록
	function fnProgramInsert() {
		let $popup = $('[data-popup=bas_program_add]');
		let $form = $popup.find('form:first');
		if ($form.find(':text[name=progrmFileNm]').val() === '') {
			toastr.warning('파일명을 입력해 주세요.');
			return;
		}
		if ($form.find(':hidden#idCheck').val() !== 'Y') {
			toastr.warning('중복체크가 안되었습니다.');
			return;	
		}
		if ($form.find(':text[name=progrmKoreannm]').val() === '') {
			toastr.warning('한글명을 입력해 주세요.');
			return;
		}
		if ($form.find(':text[name=url]').val() === '') {
			toastr.warning('URL를 입력해 주세요.');
			return;
		}
		bPopupConfirm('프로그램 등록', '등록 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/programeUpdate.do', 
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
	// 프로그램 수정
	function fnProgramUpdate() {
		let $popup = $('[data-popup=bas_program_add]');
		let $form = $popup.find('form:first');
		if ($form.find(':text[name=progrmKoreannm]').val() === '') {
			toastr.warning('한글명을 입력해 주세요.');
			return;
		}
		if ($form.find(':text[name=url]').val() === '') {
			toastr.warning('URL를 입력해 주세요.');
			return;
		}
		bPopupConfirm('프로그램 수정', '<b>'+ $form.find(':text[name=progrmFileNm]').val() +'</b> 수정 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/programeUpdate.do', 
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
	// 프로그램 삭제 호출
	function fnProgramDelete() {
		let rowId = $('#mainGrid').jqGrid('getGridParam', 'selrow');
		if (rowId === null) {
			toastr.warning('프로그램을 선택해 주세요.');
			return false;
		}
		bPopupConfirm('프로그램 삭제', '<b>'+ rowId +'</b> 를(을) 삭제 하시겠습니까?', function() {
			fnProgramDeleteConfirm(rowId);
		});
	}
	// 프로그램 삭제 확인
	function fnProgramDeleteConfirm(code) {
		bPopupConfirm('프로그램 삭제', '<b>'+ code +'</b> 를(을) 삭제하시면 시스템에 영향이 있을 수 있습니다.<br>정말로 삭제하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/programeDelete.do', {
					progrmFileNm: code
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
	// 엑셀 다운로드
	function fnExcelDownload() {
		if ($("#mainGrid").getGridParam("reccount") === 0) {
			toastr.warning('다운받으실 데이터가 없습니다.');
			return;
		}
		let params = {
			pageIndex: '1',
			pageUnit: '1000',
			searchKeyword: $('#searchKeyword').val()
		};
		EgovIndexApi.apiExecuteJson(
			'POST',
			'/backoffice/bas/progrmListAjax.do', 
			params,
			null,
			function(json) {
				let ret = json.resultlist;
				if (ret.length <= 0) {
					return;
				}
				let excelData = new Array();
				excelData.push(['NO', '파일명', '한글명', 'URL', '설명']);
				for (let idx in ret) {
					let arr = new Array();
					arr.push(Number(idx)+1);
					arr.push(ret[idx].progrm_file_nm);
					arr.push(ret[idx].progrm_koreannm);
					arr.push(ret[idx].url);
					arr.push(ret[idx].progrm_dc);
					excelData.push(arr);
				}
				let wb = XLSX.utils.book_new();
				XLSX.utils.book_append_sheet(wb, XLSX.utils.aoa_to_sheet(excelData), 'sheet1');
				var wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'binary' });
				saveAs(new Blob([EgovIndexApi.s2ab(wbout)],{ type: 'application/octet-stream' }), '프로그램관리.xlsx');
			},
			function(json) {
				toastr.error(json.message);
			}
		);
	}
</script>