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
		<li>기초 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">공통 코드 관리</li>
	</ol>
</div>
<h2 class="title">공통 코드 관리</h2>
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
        	<a href="javascript:fnCmmnDetailCodeInfo();" class="blueBtn">상세코드 등록</a>
            <a href="javascript:fnCmmnCodeInfo();" class="blueBtn">분류코드 등록</a>
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
<div data-popup="bas_code_add" class="popup m_pop">
	<div class="pop_con">
		<a class="button b-close">X</a>
        <h2 class="pop_tit"></h2>
        <div class="pop_wrap">
        	<form>
        	<input type="hidden" name="mode" value="Ins">
            <table class="detail_table">
	            <tbody>
	                <tr>
	                    <th>분류코드ID</th>
	                    <td>
	                        <input type="text" name="codeId">
	                        <span id="sp_Unqi">
	                        	<a href="javascript:fnCmmnCodeIdCheck();" class="blueBtn">중복확인</a>
	                        	<input type="hidden" id="idCheck" value="N">
	                        </span>
	                    </td>
	                </tr>
	                <tr>
	                    <th>분류코드명</th>
	                    <td><input type="text" name="codeIdNm"></td>
	                </tr>
	                <tr>
	                    <th>분류코드설명</th>
	                    <td><input type="text" name="codeIdDc" style="width:100%;"></td>
	                </tr>
	                <tr>
	                    <th>사용유무</th>
	                    <td>
                        	<input type="radio" name="useAt" value="Y">사용</input>
                        	<input type="radio" name="useAt" value="N">사용 안함</input>
	                    </td>
	                </tr>
	            </tbody>
            </table>
            </form>
        </div>
        <div style="float:left;">
            <a href="javascript:fnCmmnCodeDelete();" class="grayBtn" style="font-size:16px;padding: 6px 24px;">삭제</a>
        </div>
        <popup-right-button />
    </div>
</div>
<!-- 상세코드 추가 팝업 -->
<div data-popup="bas_detailcode_add" class="popup m_pop">
    <div class="pop_con">
    	<a class="button b-close">X</a>
        <h2 class="pop_tit"></h2>
        <div class="pop_wrap">
        	<form>
        	<input type="hidden" name="mode" value="Ins">
            <table class="detail_table">
                <tbody>
                	<tr>
                		<th>분류코드ID</th>
                		<td></td>
                	</tr>
                    <tr>
                        <th>상세코드명</th>
                        <td>
                        	<input type="hidden" name="codeId">
                            <input type="hidden" name="code">
                            <input type="text" name="codeNm">
                        </td>
                    </tr>
                    <tr>
                        <th>상세코드설명</th>
                        <td>
                            <input type="text" name="codeDc" style="width:100%;">
                        </td>
                    </tr>
                    <tr>
                        <th>기타</th>
                        <td>
                            <input type="text" name="codeEtc1" style="width:100%;">
                        </td>
                    </tr>
                    <tr>
                        <th>사용유무</th>
                        <td>
                            <span>
                               	<input type="radio" name="useAt" value="Y">사용
                               	<input type="radio" name="useAt" value="N">사용 안함
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
            </form>
        </div>
        <div style="float:left;">
            <a href="javascript:fnCmmnDetailCodeDelete();" class="grayBtn" style="font-size:16px;padding: 6px 24px;">삭제</a>
        </div>
        <popup-right-button />
    </div>
</div>
<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		// 메인 목록 정의
		EgovJqGridApi.mainGrid([
			{ label: '분류코드ID',  name:'code_id', align: 'center', fixed: true, key: true },
			{ label: '분류코드명', name:'code_id_nm', align:'center', fixed: true },
			{ label: '분류코드설명', name:'code_id_dc', align:'left', sortable: false },
			{ label: '사용유무', name:'use_at', align:'center', fixed: true },
            { label: '수정자', name:'last_updusr_id', align:'center', fixed: true },
            { label: '수정일자', name:'last_updt_pnttm', align:'center', fixed: true, formatter: 'date' },
            { label: '상세코드수', name:'child_cnt', hidden: true },
            { label: '수정', align:'center', width: 50, fixed: true, formatter: (c, o, row) =>
            	'<a href="javascript:fnCmmnCodeInfo(\''+ row.code_id +'\');" class="edt_icon"></a>'
            }
		], false, true, fnSearch).jqGrid('setGridParam', {
            isHasSubGrid: function(rowId) {
                let rowData = $('#mainGrid').jqGrid('getRowData', rowId);
                if (rowData.child_cnt === '0') {
                    return false;
                }
                return true;
            }
        });
	});
	// 메인 목록 검색
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/bas/codeListAjax.do', params, fnSearch, fnSubGrid);
	}
	// 서브 목록 정의
	function fnSubGrid(id, codeId) {
		let subGridId = id + '_t';
		$('#'+id).empty().append('<table id="'+ subGridId + '" class="scroll"></table>');
		EgovJqGridApi.subGrid(subGridId, [
			{ label: '분류코드ID', name:'code_id', hidden: true },
			{ label: '상세코드ID', name:'code', align:'center', fixed: true, key: true },
        	{ label: '상세코드명', name:'code_nm', align:'center', fixed: true },
            { label: '상세설명', name:'code_dc', align:'center', sortable: false },
            { label: '기타', name:'code_etc1', align:'center', sortable: false },
            { label: '사용유무', name:'use_at', align:'center', width: '100', fixed: true },
            { label: '수정자', name:'last_updusr_id', align:'center', width:'120', fixed: true },
            { label: '수정일자', name:'last_updt_pnttm', align:'center', width:'120', fixed: true, formatter: 'date' },
            { label: '수정', align: 'center', width: 50, fixed: true, sortable: false, formatter: (c, o, row) =>
                '<a href="javascript:fnCmmnDetailCodeInfo(\''+ subGridId +'\', \''+ row.code +'\');" class="edt_icon"></a>'
           	}
		], 'GET', '/backoffice/bas/CmmnDetailCodeList.do', {
			codeId: codeId
		});
	}
	// 분류 코드 상세 팝업 정의
	function fnCmmnCodeInfo(rowId) {
		let $popup = $('[data-popup=bas_code_add]');
		let $form = $popup.find('form:first');
		if (rowId === undefined || rowId === null) {
			$popup.find('h2:first').text('분류코드 등록');
			$popup.find('span#sp_Unqi').show();
			$popup.find('button.blueBtn').off('click').click(fnCmmnCodeInsert);
			$form.find(':hidden[name=mode]').val('Ins');
			$form.find(':text').val('');
			$form.find(':hidden#idCheck').val('N');
			$form.find(':text[name=codeId]').removeAttr('readonly');
			$form.find(':radio[name=useAt]:first').prop('checked', true);
		}
		else {
			let rowData = $('#mainGrid').jqGrid('getRowData', rowId);
			$popup.find('h2:first').text('분류코드 수정');
			$popup.find('span#sp_Unqi').hide();
			$popup.find('button.blueBtn').off('click').click(fnCmmnCodeUpdate);
			$form.find(':hidden[name=mode]').val('Edt');
			$form.find(':text[name=codeId]').prop('readonly', true).val(rowData.code_id);
			$form.find(':text[name=codeIdNm]').val(rowData.code_id_nm);
			$form.find(':text[name=codeIdDc]').val(rowData.code_id_dc);
			$form.find(':radio[name=useAt][value='+ rowData.use_at +']').prop('checked', true);
            EgovJqGridApi.selection('mainGrid', rowId);
		}
		$popup.bPopup();
	}
	// 분류코드 중복 체크
	function fnCmmnCodeIdCheck() {
		let $form = $('[data-popup=bas_code_add] form:first');
		if ($form.find(':text[name=codeId]').val() === '') {
			toastr.warning('코드를 입력해 주세요.');
			return;
		}
		EgovIndexApi.apiExecuteJson(
			'GET',
			'/backoffice/bas/codeIDCheck.do', {
				codeId: $form.find(':text[name=codeId]').val()
			},
			null,
			function(json) {
                $form.find(':hidden#idCheck').val('Y');
				toastr.info(json.message);
			},
			function(json) {
				toastr.warning(json.message);
			}
		);
	}
	// 분류 코드 등록
	function fnCmmnCodeInsert() {
		let $popup = $('[data-popup=bas_code_add]');
		let $form = $popup.find('form:first');
		if ($form.find(':text[name=codeId]').val() === '') {
			toastr.warning('코드를 입력해 주세요.');
			return;
		}
		if ($form.find(':hidden#idCheck').val() !== 'Y') {
			toastr.warning('중복체크가 안되었습니다.');
			return;	
		}
		if ($form.find(':text[name=codeIdNm]').val() === '') {
			toastr.warning('코드명을 입력해 주세요.');
			return;
		}
		bPopupConfirm('분류코드 등록', '등록 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/codeUpdate.do', 
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
	// 분류 코드 수정
	function fnCmmnCodeUpdate() {
		let $popup = $('[data-popup=bas_code_add]');
		let $form = $popup.find('form:first');
		if ($form.find(':text[name=codeIdNm]').val() === '') {
			toastr.warning('코드명을 입력해 주세요.');
			return;
		}
		bPopupConfirm('분류코드 수정', '<b>'+ $form.find(':text[name=codeId]').val() +'</b> 를(을) 수정 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/codeUpdate.do', 
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
	// 분류 코드 삭제
	function fnCmmnCodeDelete() {
        let $popup = $('[data-popup=bas_code_add]');
        let rowId = $popup.find(':text[name=codeId]').val();
		bPopupConfirm('분류코드 삭제', '<b>'+ rowId +'</b> 를( 을) 삭제 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/codeDelete.do', {
					codeId: rowId
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
	// 상세 코드 팝업 정의
	function fnCmmnDetailCodeInfo(id, rowId) {
		let $popup = $('[data-popup=bas_detailcode_add]');
		let $form = $popup.find('form:first');
		if (id === undefined || id === null) {
			let rowId = $('#mainGrid').jqGrid('getGridParam', 'selrow');
			if (rowId === null) {
				toastr.warning('분류코드를 선택해 주세요.');
				return false;
			}
			$popup.find('h2:first').text('상세코드 등록');
			$popup.find('td:first').html(rowId);
			$popup.find('button.blueBtn').off('click').click(fnCmmnDetailCodeInsert);
			$form.find(':text').val('');
			$form.find(':hidden[name=codeId]').val(rowId);
			$form.find(':radio[name=useAt]:first').prop('checked', true);
			$form.find(':hidden[name=mode]').val('Ins');
		}
		else {
            let rowData = $('#'+id).jqGrid('getRowData', rowId);
			$popup.find('h2:first').text('상세코드 수정');
			$popup.find('td:first').html(rowData.code_id);
			$popup.find('button.blueBtn').off('click').click(fnCmmnDetailCodeUpdate);
			$form.find(':hidden[name=codeId]').val(rowData.code_id);
			$form.find(':hidden[name=code]').val(rowData.code);
			$form.find(':text[name=codeNm]').val(rowData.code_nm);
			$form.find(':text[name=codeDc]').val(rowData.code_dc);
			$form.find(':text[name=codeEtc1]').val(rowData.code_etc1);
			$form.find(':radio[name=useAt][value='+ rowData.use_at +']').prop('checked', true);
			$form.find(':hidden[name=mode]').val('Edt');
		}
		$popup.bPopup();
	}
	// 상세 코드 등록
	function fnCmmnDetailCodeInsert() {
		let $popup = $('[data-popup=bas_detailcode_add]');
		let $form = $popup.find('form:first');
		if ($form.find(':text[name=codeNm]').val() === '') {
			toastr.warning('상세코드명을 입력해 주세요.');
			return;
		}
		bPopupConfirm('상세코드 등록', '등록 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/CodeDetailUpdate.do', 
				$form.serializeObject(),
				null,
				function(json) {
                    EgovJqGridApi.subGridReload($form.find(':hidden[name=codeId]').val(), fnSubGrid);
					toastr.success(json.message);
					$popup.bPopup().close();
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	// 상세 코드 수정
	function fnCmmnDetailCodeUpdate() {
		let $popup = $('[data-popup=bas_detailcode_add]');
		let $form = $popup.find('form:first');
		if ($form.find(':text[name=codeNm]').val() === '') {
			toastr.warning('상세코드명을 입력해 주세요.');
			return;
		}
		bPopupConfirm('상세코드 수정', '<b>'+ $form.find(':hidden[name=code]').val() +'</b> 수정 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson( 
				'POST',
				'/backoffice/bas/CodeDetailUpdate.do', 
				$form.serializeObject(),
				null,
				function(json) {
                    EgovJqGridApi.subGridReload($form.find(':hidden[name=codeId]').val(), fnSubGrid);
					toastr.success(json.message);
					$popup.bPopup().close();
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	// 상세 코드 삭제
	function fnCmmnDetailCodeDelete() {
        let $popup = $('[data-popup=bas_detailcode_add]');
        let rowId = $popup.find(':hidden[name=code]').val();
		bPopupConfirm('상세코드 삭제', '<b>'+ rowId +'</b> 를(을) 삭제 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/codeDetailCodeDelete.do', {
					code: rowId
				},
				null,
				function(json) {
                    EgovJqGridApi.subGridReload($form.find(':hidden[name=codeId]').val(), fnSubGrid);
					toastr.success(json.message);
                    $popup.bPopup().close();
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
</script>