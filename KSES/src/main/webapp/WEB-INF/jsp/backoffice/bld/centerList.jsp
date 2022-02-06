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
				<div id="floor" class="tab">층관리</div>
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
			{ label: '사용유무', name: 'use_yn', align: 'center', width: 70, fixed: true },
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
			let colModel = [];
			switch ($(this).attr('id')) {
				case 'preopen':
					MainGridAjaxUrl = '/backoffice/bld/preOpenInfoListAjax.do';
					EgovJqGridApi.mainGrid([
						{ label: '사전예약입장시간코드', name: 'optm_cd', key: true, hidden:true },
						{ label: '요일', name: 'open_day_text', align: 'center', sortable: false },
						{ label: '회원오픈시간', name: 'open_member_tm', align: 'center', sortable: false, editable: true, editoptions: { size: 5, maxlength: 5 } },
						{ label: '회원종료시간', name: 'close_member_tm', align: 'center', sortable: false, editable: true, editoptions: { size: 5, maxlength: 5 } },
						{ label: '비회원오픈시간', name: 'open_guest_tm', align: 'center', sortable: false, editable: true, editoptions: { size: 5, maxlength: 5 } },
						{ label: '비회원종료시간', name: 'close_guest_tm', align: 'center', sortable: false, editable: true, editoptions: { size: 5, maxlength: 5 } },
					], false, false, fnSearch, false).jqGrid('setGridParam', {
						cellEdit: true,
						cellsubmit: 'clientArray'
					});
					$('#rightAreaUqBtn').html(
						'<a href="javascript:void(0);" class="orangeBtn">복사</a>'
					).show();
					$('#rightAreaBtn').show();
					break;
				case 'noshow':
					MainGridAjaxUrl = '/backoffice/bld/noshowInfoListAjax.do';
					EgovJqGridApi.mainGrid([
						{ label: '노쇼코드', name: 'noshow_cd', key: true, hidden:true },
						{ label: '요일', name: 'noshow_day_text', align: 'center', sortable: false },
						{ label: '1차자동취소시간', name: 'noshow_pm_tm', align: 'center', sortable: false, editable: true, editoptions: { size: 5, maxlength: 5 } },
						{ label: '2차자동취소시간', name: 'noshow_all_tm', align: 'center', sortable: false, editable: true, editoptions: { size: 5, maxlength: 5 } },
					], false, false, fnSearch, false).jqGrid('setGridParam', {
						cellEdit: true,
						cellsubmit: 'clientArray'
					});
					$('#rightAreaBtn').show();
					break;
				case 'floor':
					MainGridAjaxUrl = '/backoffice/bld/floorListAjax.do';
					EgovJqGridApi.mainGrid([
						{ label: '지점층코드', name: 'floor_cd', key: true, hidden: true },
						{ label: '도면이미지', name: 'floor_map1', align: 'center', sortable: false, formatter: (c, o, row) =>
							'<img src="'+ (row.floor_map1 === 'no_image.png' ? '/resources/img/no_image.png' : '/upload/'+ row.floor_map1) +'" style="width:120px;"/>'
						},
						{ label: '층이름', name: 'floor_nm', align: 'center', sortable: false },
						{ label: '좌석 현황', name:'floor_seat_cnt', align: 'center', sortable: false },
						{ label: '사용 유무', name:'use_yn', align: 'center', sortable: false },
						{ label: '구역사용구분', name:'floor_part_dvsn', hidden: true },
						{ label: '수정', align:'center', sortable: false, width: 50, fixed: true, formatter: (c, o, row) =>
							'<a href="javascript:void(0);" class="edt_icon"></a>'
						}
					], false, true, fnSearch, false);
					break;
				case 'holyday':
					MainGridAjaxUrl = '/backoffice/bld/centerHolyInfoListAjax.do';
					EgovJqGridApi.mainGrid([
						{ label: '지점휴일시퀀스', name: 'center_holy_seq', key: true, hidden: true },
						{ label: '휴일일자', name: 'holy_dt', align: 'center', sortable: false },
						{ label: '휴일명', name: 'holy_nm', align: 'center', sortable: false, editable: true },
						{ label: '사용유무', name: 'use_yn', align: 'center', sortable: false, formatter: 'select',
							editable: true, edittype: 'select', editoptions: {
								value: 'Y:사용;N:사용안함'
							}
						},
					], false, false, fnSearch, false).jqGrid('setGridParam', {
						cellEdit: true,
						cellsubmit: 'clientArray'
					});
					$('#rightAreaBtn').show();
					break;
				case 'billday':
					MainGridAjaxUrl = '/backoffice/bld/billDayInfoListAjax.do';
					EgovJqGridApi.mainGrid([
						{ label: '요일코드', name: 'billday_cd', key: true, hidden: true },
						{ label: '요일', name: 'bill_day_text', align: 'center', sortable: false },
						{ label: '발급구분', name: 'bill_seq', align: 'center', sortable: false, formatter: (cellvalue, o, row) => {
								let html = '<select data-rowId="'+ row.billday_cd +'">';
								html += '<option value="">사용안함</option>';
								for (let item of row.bill_info_list) {
									html += (item.bill_seq === cellvalue)
										? '<option value="'+ item.bill_seq + '" selected>'+ item.bill_dvsn_text +'</option>'
										: '<option value="'+ item.bill_seq + '">'+ item.bill_dvsn_text +'</option>';
								}
								html += '</select>';
								return html;
							}
						},
						{ label: '법인명', name: 'bill_corp_name', align: 'center', sortable: false },
						{ label: '사업자번호', name: 'bill_num', align: 'center', sortable: false },
					], false, false, fnSearch, false).jqGrid('setGridParam', {
						cellEdit: true,
						cellsubmit: 'clientArray'
					});
					$('#rightAreaBtn').show();
					break;
				default:
			}
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
			EgovJqGridApi.mainGridAjax(MainGridAjaxUrl, params, fnSearch, fnSubGrid);
		} else {
			EgovJqGridApi.mainGridAjax(MainGridAjaxUrl, params, fnSearch);
		}
	}

	function fnSubGrid(id, parentId) {
		let subGridId = id + '_t';
		$('#'+id).empty().append('<table id="'+ subGridId + '" class="scroll"></table>');
		EgovJqGridApi.subGrid(subGridId, [
			{ label: '구역코드', name:'part_cd', key: true, hidden: true },
			{ label: '도면이미지', name: 'part_map1', align: 'center', sortable: false, formatter: (c, o, row) =>
				'<img src="'+ (row.part_map1 === 'no_image.png' || row.part_map1 === undefined ? '/resources/img/no_image.png'
						: '/upload/'+ row.part_map1) +'" style="width:120px;"/>'
			},
			{ label: '구역명', name: 'part_nm', align: 'center' },
			{ label: '사용여부', name: 'use_yn', align: 'center' },
		], 'POST', '/backoffice/bld/partListAjax.do', {
			floorCd: parentId
		});
	}

	function fnRightAreaSave() {
		let changedArr = $('#mainGrid').jqGrid('getChangedCells');
		if (changedArr.length === 0) {
			toastr.info('수정된 목록이 없습니다.');
			return;
		}
		let title = '';
		let ajaxUrl = '';
		let params = [];
		for (let item of changedArr) {
			switch ($('div.tabs .tab.active').attr('id')) {
				case 'preopen':
					title = '사전예약 수정';
					ajaxUrl = '/backoffice/bld/preOpenInfoUpdate.do';
					params.push({
						optmCd: item.optm_cd,
						openMemberTm: item.open_member_tm.replace(/\:/g,''),
						openGuestTm: item.open_guest_tm.replace(/\:/g,''),
						closeMemberTm: item.close_member_tm.replace(/\:/g,''),
						closeGuestTm: item.close_guest_tm.replace(/\:/g,'')
					});
					break;
				case 'noshow':
					title = '자동취소 수정';
					ajaxUrl = '/backoffice/bld/noshowInfoUpdate.do';
					params.push({
						noshowCd: item.noshow_cd.replace(/\:/g,''),
						noshowPmTm: item.noshow_pm_tm.replace(/\:/g,''),
						noshowAllTm: item.noshow_all_tm.replace(/\:/g,'')
					});
					break;
				default:
			}
		}
		bPopupConfirm(title, changedArr.length +'건에 대해 수정 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				ajaxUrl,
				params,
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