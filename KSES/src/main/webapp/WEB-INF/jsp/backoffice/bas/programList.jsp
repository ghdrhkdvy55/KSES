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
<script type="text/javascript" src="/resources/js/xlsx.js"></script>
<script type="text/javascript" src="/resources/js/xlsx.full.min.js"></script>
<!-- jszip -->
<script type="text/javascript" src="/resources/js/jszip.min.js"></script>
<!-- //contents -->
<input type="hidden" id="mode" name="mode" />
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
			<a href="javascript:void(0);" class="blueBtn">엑셀 다운로드</a> 
        	<a href="javascript:fnProgramInfo();" class="blueBtn">프로그램 등록</a>
        	<a href="javascript:void(0);" class="grayBtn">프로그램 삭제</a>            	
        </div>
         
        <div class="clear"></div>
        <div class="whiteBox">
            <table id="mainGrid"></table>
            <div id="pager" class="scroll" style="text-align:center;"></div>  
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
						<th>프로그램 파일명</th>
						<td>
						    <input type="text" name="progrmFileNm">
						    <span id="sp_Unqi">
                            	<a href="javascript:fnIdCheck();" class="blueBtn">중복확인</a>
                            	<input type="hidden" id="idCheck" value="N">
                            </span>
						</td>
					</tr>
					<tr>
						<th>지정 경로</th>
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
        	<buuton class="blueBtn">등록</buuton>
            <buuton class="grayBtn b-close">취소</buuton>
        </div>
        <div class="clear"></div>
    </div>
</div>
<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		EgovJqGridApi.mainGrid([
			{ label: '프로그램 파일명', name: 'progrm_file_nm', align: 'left', fixed: true },
			{ label: '프로그램명',  name: 'progrm_koreannm', align: 'left', fixed: true },
			{ label: 'URL', name:'url', align: 'left' },
			{ label: '프로그램설명', name: 'progrm_dc', align: 'left', sortable: false }
		], false, false, fnSearch);
	});
	
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/bas/progrmListAjax.do', params, fnSearch);
		EgovJqGridApi.mainGridDetail(fnProgramInfo);
	}
	
	function fnProgramInfo(id, rowData) {
		let $popup = $('[data-popup=bas_program_add]');
		let $form = $popup.find('form:first');
		if (id === undefined || id === null) {
			$popup.find('h2:first').text('프로그램 등록');
			$popup.find('span#sp_Unqi').show();
			$popup.find('button.blueBtn').off('click').click(fnProgramInsert);
			$form.find(':hidden[name=mode]').val('Ins');
			$form.find(':text').val('');
			$form.find('textarea').val('');
		}
		else {
			$popup.find('h2:first').text('프로그램 수정');
			$popup.find('span#sp_Unqi').hide();
			$popup.find('button.blueBtn').off('click').click(fnProgramUpdate);
			$form.find(':hidden[name=mode]').val('Edt');
		}
		$popup.bPopup();
	}
	
	function fnProgramInsert() {
		let $popup = $('[data-popup=bas_program_add]');
	}
	
	function fnProgramUpdate() {
		let $popup = $('[data-popup=bas_program_add]');
	}
	
	function fnProgramDelete() {
		let rowId = $('#mainGrid').jqGrid('getGridParam', 'selrow');
	}
</script>