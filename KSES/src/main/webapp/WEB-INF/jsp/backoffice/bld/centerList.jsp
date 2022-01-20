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
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>시설 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">지점 관리</li>
	</ol>
</div>
<h2 class="title">지점 관리</h2>
<div class="clear"></div>
<div class="dashboard">
	<div class="boardlist">
		<div class="box_shadow custom_bg custom_bg02 xs-6">
			<div class="whiteBox searchBox">
				<div class="top">
					<p>지점명</p>
					<input type="text" id="searchKeyword" placeholder="검색어를 입력하세요.">
				</div>
				<div class="inlineBtn">
					<a href="javascript:fnCenterSearch(1);" class="grayBtn">검색</a>
				</div>
				<div class="right_box">
					<a href="javascript:void(0);" class="blueBtn">지점 등록</a>
					<a href="javascript:void(0);" class="grayBtn">삭제</a>
				</div>
			</div>
			<div class="clear"></div>
			<div class="whiteBox">
				<table id="centerGrid"></table>
				<div id="centerPager"></div>
			</div>
		</div>
		<div class="xs-6">
			<div class="tabs blacklist" style="margin-top:33px;">
				<div id="preopen" class="tab">사전예약시간</div>
				<div id="noshow" class="tab">자동취소</div>
				<div id="floor" class="tab">층관리</div>
				<div id="holyday" class="tab">휴일관리</div>
			</div>
			<div class="clear"></div>
			<div id="rightArea" class="whiteBox" style="margin-top:28px;"></div>
		</div>
	</div>
</div>
<!-- contents//-->
<!-- //popup -->

<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		// 지점 JqGrid 정의
		EgovJqGridApi.popGrid('centerGrid', [
			{ label: '지점코드', name: 'center_cd', key: true, hidden:true },
			{ label: '지점', name:'center_img', align: 'center', sortable: false, formatter: (c, o, row) => 
				'<img src="'+ (row.center_img === 'no_image.png' ? '/resources/img/no_image.png' : '/upload/'+ row.center_img) +'" style="width:120px;"/>'
			},
			{ label: '지점명', name: 'center_nm', align: 'center' },
			{ label: '연락처', name: 'center_tel',  align: 'center', sortable: false },
			{ label: '사용유무', name: 'use_yn', align: 'center' },
			{ label: '최대자유석수', name: 'center_stand_max', align:'center' },
			{ label: '수정', align:'center', width: 50, fixed: true, formatter: (c, o, row) =>
            	'<a href="javascript:void(0);" class="edt_icon"></a>'
            }
		], 'centerPager').jqGrid('setGridParam', {
			onSelectRow: function(rowId, status, e) {
				if ($('#mainGrid').contents() > 0) {
					fnSearch(1);
				}
			},
			gridComplete: function() {
				$('div.tabs .tab').removeClass('active');
				fnRightClear();
			}
		});
		// 하위 분류 탭 클릭 시
		$('div.tabs .tab').click(function(e) {
			let rowId = $('#centerGrid').jqGrid('getGridParam', 'selrow');
			if (rowId === null) {
				toastr.info('지점을 선택해주세요.');
				return;
			}
			$('div.tabs .tab').removeClass('active');
			$(this).addClass('active');
			fnRightClear();
			let colModel = [];
			switch ($(this).attr('id')) {
				case 'preopen':
					EgovJqGridApi.mainGrid([
						{ label: '사전예약입장시간코드', name: 'optm_cd', key: true, hidden:true },
						{ label: '요일', name: 'open_day_text', align: 'center', sortable: false },
						{ label: '회원오픈시간', name: 'open_member_tm', align: 'center', sortable: false, editable: true },
						{ label: '회원종료시간', name: 'close_member_tm', align: 'center', sortable: false, editable: true },
						{ label: '비회원오픈시간', name: 'open_guest_tm', align: 'center', sortable: false, editable: true },
						{ label: '비회원종료시간', name: 'close_guest_tm', align: 'center', sortable: false, editable: true },
					], false, false, fnSearch, false).jqGrid('setGridParam', {
						cellEdit: true,
						
					});
					break;
				case 'noshow':
					colModel = [
					];
					break;
				case 'floor':
					colModel = [
					];
					break;
				case 'holyday':
					colModel = [
					];
					break;
				default:
			}
			
		});
		fnRightClear();
		setTimeout(function() {
			fnCenterSearch(1);
		}, _JqGridDelay);
	});
	// 지점 목록 검색
	function fnCenterSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('#centerGrid .ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val()
		};
		EgovJqGridApi.popGridAjax('centerGrid', '/backoffice/bld/centerListAjax.do', params, fnCenterSearch);
	}
	// 하위 목록 영역 초기화
	function fnRightClear() {
		$('#rightArea').empty().html(
			'<table id="mainGrid" style="width:700px;"></table>'+
			'<div id="pager"></div>'
		);
	}
	// 하위 목록 조회
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: '10',
			centerCd: $('#centerGrid').jqGrid('getGridParam', 'selrow')
		};
		console.log(params);
		EgovJqGridApi.mainGridAjax('/backoffice/bld/preOpenInfoListAjax.do', params, fnSearch);
	}
</script>