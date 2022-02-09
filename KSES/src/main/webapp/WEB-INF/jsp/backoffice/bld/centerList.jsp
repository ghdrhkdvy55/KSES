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
					<a href="javascript:void(0);" class="blueBtn">현금영수증 설정</a>
					<a href="javascript:void(0);" class="blueBtn">지점 등록</a>
					<a href="javascript:void(0);" class="grayBtn">지점 삭제</a>
				</div>
			</div>
			<div class="clear"></div>
			<div class="whiteBox">
				<table id="centerGrid"></table>
				<div id="centerPager"></div>
			</div>
		</div>
		<div class="xs-6">
			<div style="font-size:14px;color:#333;margin-top:12px;margin-left:5px;">
				지점:&nbsp;<span id="spCenterNm">선택되지 않음</span>
			</div>
			<div class="tabs blacklist">
				<div id="preopen" class="tab">사전예약시간</div>
				<div id="noshow" class="tab">자동취소</div>
				<div id="holyday" class="tab">휴일관리</div>
				<div id="billday" class="tab">현금영수증(요일)</div>
				<div id="floor" class="tab">층정보</div>
			</div>
			<div class="clear"></div>
			<div id="rightArea" style="margin-top:28px;"></div>
			<div id="rightAreaUqBtn" style="float:left;margin-top:10px;display:none;"></div>
			<div id="rightAreaBtn" class="right_box" style="display:none;">
				<a href="javascript:fnRightAreaSave();" class="blueBtn">저장</a>
			</div>
		</div>
	</div>
</div>
<!-- contents//-->
<!-- //popup -->

<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	let MainGridAjaxUrl = '';
	$(document).ready(function() {
		// 지점 JqGrid 정의
		EgovJqGridApi.popGrid('centerGrid', [
			{ label: '지점코드', name: 'center_cd', key: true, hidden:true },
			{ label: '지점', name:'center_img', align: 'center', width: 80, fixed: true, sortable: false, formatter: (c, o, row) =>
				'<img src="'+ (row.center_img === 'no_image.png' ? '/resources/img/no_image.png' : '/upload/'+ row.center_img) +'" style="width:120px;"/>'
			},
			{ label: '지점명', name: 'center_nm', align: 'center', width: 100, fixed: true },
			{ label: '연락처', name: 'center_tel',  align: 'center', sortable: false },
			{ label: '현금영수증', name: 'bill_yn', align: 'center', width: 70, fixed: true },
			{ label: '사용여부', name: 'use_yn', align: 'center', width: 70, fixed: true },
			{ label: '최대자유석수', name: 'center_stand_max', align:'center', width: 80, fixed: true },
			{ label: '수정', align:'center', width: 50, fixed: true, formatter: (c, o, row) =>
            	'<a href="javascript:void(0);" class="edt_icon"></a>'
            }
		], 'centerPager', [10, 20]).jqGrid('setGridParam', {
			onSelectRow: function(rowId, status, e) {
				if ($('#mainGrid').contents().length > 0) {
					fnSearch(1);
				}
				let rowData = $('#centerGrid').jqGrid('getRowData', rowId);
				$('#spCenterNm').text(rowData.center_nm);
			},
			gridComplete: function() {
				$('div.tabs .tab').removeClass('active');
				fnRightAreaClear();
				$('#rightArea').html('<b>지점 선택 후 상위 메뉴 탭을 클릭 시 목록이 조회됩니다.</b>');
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
			fnRightAreaClear();
			switch ($(this).attr('id')) {
				case 'preopen':
					Preopen.mainGridSettings();
					break;
				case 'noshow':
					Noshow.mainGridSettings();
					break;
				case 'holyday':
					Holyday.mainGridSettings();
					break;
				case 'billday':
					Billday.mainGridSettings();
					break;
				case 'floor':
					Floor.mainGridSettings();
					break;
				default:
			}
			// jqGrid EditCell 관련 버그 패치 추가
			$(document).on('focusout', '[role=gridcell] select', function(e) {
				$('#mainGrid').editCell(0, 0, false);
			});
		});
		setTimeout(function() {
			fnCenterSearch(1);
		}, _JqGridDelay);
	});
	// 지점 목록 검색
	function fnCenterSearch(pageNo) {
		$('#spCenterNm').text('선택되지 않음');
		let params = {
			pageIndex: pageNo,
			pageUnit: $('#centerPager .ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val()
		};
		EgovJqGridApi.popGridAjax('centerGrid', '/backoffice/bld/centerListAjax.do', params, fnCenterSearch);
	}
	// 하위 목록 영역 초기화
	function fnRightAreaClear() {
		$('#rightArea').empty().html(
			'<table id="mainGrid" style="width:700px;"></table>'+
			'<div id="pager"></div>'
		);
		$('#rightAreaUqBtn').html('').hide();
		$('#rightAreaBtn').hide();
	}
	// 하위 목록 조회
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('#pager .ui-pg-selbox option:selected').val(),
			centerCd: $('#centerGrid').jqGrid('getGridParam', 'selrow')
		};
		if ($('div.tabs .tab.active').attr('id') === 'floor') {
			EgovJqGridApi.mainGridAjax(MainGridAjaxUrl, params, fnSearch, Floor.subFloorPartGrid);
		} else {
			EgovJqGridApi.mainGridAjax(MainGridAjaxUrl, params, fnSearch);
		}
	}

	function fnRightAreaSave() {
		let tabMenu = $('div.tabs .tab.active').attr('id');
		let changedArr = $('#mainGrid').jqGrid('getChangedCells', 'all');
		if (tabMenu === 'billday') {
			changedArr = Billday.changedArray();
		}
		if (changedArr.length === 0) {
			toastr.info('수정된 목록이 없습니다.');
			return;
		}
		let ajaxUpdate = { title: '', url: '', params: [] };
		switch (tabMenu) {
			case 'preopen':
				Preopen.updateSettings(ajaxUpdate, changedArr);
				break;
			case 'noshow':
				Noshow.updateSettings(ajaxUpdate, changedArr);
				break;
			case 'holyday':
				Holyday.updateSettings(ajaxUpdate, changedArr);
				break;
			case 'billday':
				Billday.updateSettings(ajaxUpdate, changedArr);
				break;
			case 'floor':
				Floor.updateSettings(ajaxUpdate, changedArr);
				break;
			default:
		}
		bPopupConfirm(ajaxUpdate.title, changedArr.length +'건에 대해 수정 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				ajaxUpdate.url,
				ajaxUpdate.params,
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
</script>
<script type="text/javascript" src="/resources/js/backoffice/bld/centerList.preopen.js"></script>
<script type="text/javascript" src="/resources/js/backoffice/bld/centerList.noshow.js"></script>
<script type="text/javascript" src="/resources/js/backoffice/bld/centerList.holyday.js"></script>
<script type="text/javascript" src="/resources/js/backoffice/bld/centerList.billday.js"></script>
<script type="text/javascript" src="/resources/js/backoffice/bld/centerList.floor.js"></script>