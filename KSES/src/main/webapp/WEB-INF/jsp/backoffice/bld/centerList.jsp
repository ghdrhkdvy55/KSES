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
					<a href="javascript:fnCenterInfo();" class="blueBtn">지점 등록</a>
					<a href="javascript:fnCenterDelete();" class="grayBtn">지점 삭제</a>
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
<div data-popup="bld_center_add" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
		<h2 class="pop_tit">지점 등록</h2>
		<div class="pop_wrap">
			<form>
			<input type="hidden" name="mode" value="Ins">
			<table class="detail_table">
				<tbody>
				<tr>
					<th>지점명</th>
					<td>
						<input type="hidden" name="centerCd">
						<input type="text" name="centerNm">
					</td>
					<th>주소</th>
					<td>
						<input type="text" name="centerAddr1" style="width:200px;margin-right:5px;">
						<input type="text" name="centerAddr2" style="width:200px;margin-right:5px;">
					</td>
				</tr>
				<tr>
					<th>대표번호</th>
					<td><input type="text" name="centerTel" maxlength="15"></td>
					<th>Fax</th>
					<td><input type="text" name="centerFax" maxlength="15"></td>
				</tr>
				<tr>
					<th>전경 사진</th>
					<td><input type="file" name="centerImgFile"></td>
					<th>내부 이미지</th>
					<td><input type="file" name="centerMapFile"></td>
				</tr>
				<tr>
					<th>전체 사용 층</th>
					<td>
						<select name="startFloor">
							<option value="">시작 층수</option>
							<c:forEach items="${floorInfo}" var="floor">
								<option value="${floor.code}"><c:out value='${floor.codenm}'/></option>
							</c:forEach>
						</select> ~
						<select name="endFloor">
							<option value="">종료 층수</option>
							<c:forEach items="${floorInfo}" var="floor">
								<option value="${floor.code}"><c:out value='${floor.codenm}'/></option>
							</c:forEach>
						</select>
					</td>
					<th>정렬 순서</th>
					<td><input type="text" name="centerOrder" numberonly></td>
				</tr>
				<tr>
					<th>URL</th>
					<td><input type="text" name="centerUrl" style="width:100%;"></td>
					<th>사용 여부</th>
					<td>
						<input type="radio" name="useYn" value="Y">사용</input>
						<input type="radio" name="useYn" value="N">사용 안함</input>
					</td>
				</tr>
				<tr>
					<th>시범 지점 여부</th>
					<td>
						<input type="radio" name="centerPilotYn" value="Y">사용</input>
						<input type="radio" name="centerPilotYn" value="N">사용 안함</input>
					</td>
					<th>입석 사용 여부</th>
					<td>
						<input type="radio" name="centerStandYn" value="Y">사용</input>
						<input type="radio" name="centerStandYn" value="N">사용 안함</input>
					</td>
				</tr>
				<tr>
					<th>최대 자유석수</th>
					<td><input type="text" name="centerStandMax" numberonly></td>
					<th>지점 입장료</th>
					<td><input type="text" name="centerEntryPayCost" numberonly></td>
				</tr>
				<tr>
					<th>스피온 코드</th>
					<td><input type="text" name="centerSpeedCd" maxlength="15"></td>
					<th>QR 체크 코드</th>
					<td><input type="text" name="centerRbmCd" maxlength="2"></td>
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
            	'<a href="javascript:fnCenterInfo(\''+ row.center_cd +'\');" class="edt_icon"></a>'
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
	// 지점 상세
	function fnCenterInfo(rowId) {
		let $popup = $('[data-popup=bld_center_add]');
        let $form = $popup.find('form:first');
        if (rowId === undefined || rowId === null) {
            $popup.find('h2.2:first').text('지점 등록');
			$popup.find('button.blueBtn').off('click').click(fnCenterInsert);
			$form.find(':hidden[name=mode]').val('Ins');
			$form.find(':text').val('');
			$form.find(':text[name=centerTel]').val('02-3422-0000');
			$form.find(':text[name=centerFax]').val('02-3422-0001');
			$form.find(':text[name=centerOrder]').val(0);
			$form.find(':text[name=centerStandMax]').val(0);
			$form.find(':text[name=centerEntryPayCost]').val(0);
			$form.find('select[name=startFloor] option:first').prop('selected', true);
			$form.find('select[name=endFloor] option:first').prop('selected', true);
			$form.find(':radio[name=useYn]:first').prop('checked', true);
			$form.find(':radio[name=centerPilotYn]:first').prop('checked', true);
			$form.find(':radio[name=centerStandYn]:first').prop('checked', true);
			$popup.bPopup();
        } else {
            $popup.find('h2:first').text('지점 수정');
			$popup.find('button.blueBtn').off('click').click(fnCenterUpdate);
			EgovIndexApi.apiExecuteJson(
				'GET',
				'/backoffice/bld/centerInfoDetail.do', {
					centerCd: rowId
				},
				null,
				function(json) {
					let data = json.result;
					$form.find(':hidden[name=mode]').val('Edt');
					$form.find(':file').val('');
					$form.find(':hidden[name=centerCd]').val(data.center_cd);
					$form.find(':text[name=centerNm]').val(data.center_nm);
					$form.find(':text[name=centerAddr1]').val(data.center_addr1);
					$form.find(':text[name=centerAddr2]').val(data.center_addr2);
					$form.find(':text[name=centerTel]').val(data.center_tel);
					$form.find(':text[name=centerFax]').val(data.center_fax);
					$form.find('select[name=startFloor]').val(data.start_floor);
					$form.find('select[name=endFloor]').val(data.end_floor);
					$form.find(':text[name=centerOrder]').val(data.center_order);
					$form.find(':text[name=centerUrl]').val(data.center_url);
					$form.find(':radio[name=useYn][value='+ data.use_yn +']').prop('checked', true);
					$form.find(':radio[name=centerPilotYn][value='+ data.center_pilot_yn +']').prop('checked', true);
					$form.find(':radio[name=centerStandYn][value='+ data.center_stand_yn +']').prop('checked', true);
					$form.find(':text[name=centerStandMax]').val(data.center_stand_max);
					$form.find(':text[name=centerEntryPayCost]').val(data.center_entry_pay_cost);
					$form.find(':text[name=centerSpeedCd]').val(data.center_speed_cd);
					$form.find(':text[name=centerRbmCd]').val(data.center_rbm_cd);
					$popup.bPopup();
				},
				function(json) {
					toastr.warning(json.message);
				}
			);
        }
	}
	// 지점 등록
	function fnCenterInsert() {
		let $popup = $('[data-popup=bld_center_add]');
		let $form = $popup.find('form:first');
		if ($form.find(':text[name=centerNm]').val() === '') {
			toastr.warning('지점명을 입력해 주세요.');
			return;
		}
		let formData = new FormData($form[0]);
		if ($form.find('select[name=startFloor]').val() !== '' && $form.find('select[name=endFloor]').val()) {
			let startFloor = $form.find('select[name=startFloor]').val().replace('CENTER_FLOOR_','');
			let endFloor = $form.find('select[name=endFloor]').val().replace('CENTER_FLOOR_','');
			if (parseInt(startFloor) > parseInt(endFloor)) {
				toastr.warning('시작 층수가 종료 층수보다 큽니다.');
				return;
			}
			let floorInfo = new Array();
			for (let i = startFloor; i<=endFloor; i++) {
				floorInfo.push(i);
			}
			formData.append('floorInfo', floorInfo.join(','));
		}
		bPopupConfirm('지점 등록', '등록 하시겠습니까?', function() {
			EgovIndexApi.apiExcuteMultipart(
				'/backoffice/bld/centerInfoUpdate.do',
				formData,
				null,
				function(json) {
					toastr.success(json.message);
					$popup.bPopup().close();
					fnCenterSearch(1);
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	};
	// 지점 수정
	function fnCenterUpdate() {
		let $popup = $('[data-popup=bld_center_add]');
		let $form = $popup.find('form:first');
		if ($form.find(':text[name=centerNm]').val() === '') {
			toastr.warning('지점명을 입력해 주세요.');
			return;
		}
		let formData = new FormData($form[0]);
		if ($form.find('select[name=startFloor]').val() !== '' && $form.find('select[name=endFloor]').val()) {
			let startFloor = $form.find('select[name=startFloor]').val().replace('CENTER_FLOOR_','');
			let endFloor = $form.find('select[name=endFloor]').val().replace('CENTER_FLOOR_','');
			if (parseInt(startFloor) > parseInt(endFloor)) {
				toastr.warning('시작 층수가 종료 층수보다 큽니다.');
				return;
			}
			let floorInfo = new Array();
			for (let i = startFloor; i<=endFloor; i++) {
				floorInfo.push(i);
			}
			formData.append('floorInfo', floorInfo.join(','));
		}
		bPopupConfirm('지점 수정', '<b>'+ $form.find(':text[name=centerNm]').val() +'</b>&nbsp;을(를) 수정 하시겠습니까?', function() {
			EgovIndexApi.apiExcuteMultipart(
				'/backoffice/bld/centerInfoUpdate.do',
				formData,
				null,
				function(json) {
					toastr.success(json.message);
					$popup.bPopup().close();
					fnCenterSearch(1);
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	// 지점 삭제
	function fnCenterDelete() {
		let rowId = $('#centerGrid').jqGrid('getGridParam', 'selrow');
		if (rowId === null) {
			toastr.warning('지점을 선택해 주세요.');
			return false;
		}
		let rowData = $('#centerGrid').jqGrid('getRowData', rowId);
		bPopupConfirm('지점 삭제', '<b>'+ rowData.center_nm +'</b> 를(을) 삭제 하시겠습니까?', function() {
			fnCenterDeleteConfirm(rowId, rowData.center_nm);
		});
	}
	// 지점 삭제 확인
	function fnCenterDeleteConfirm(centerCd, centerNm) {
		bPopupConfirm('지점 삭제', '<b>'+ centerNm +'</b> 를(을) 삭제하시면 시스템에 영향이 있을 수 있습니다.<br>정말로 삭제하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bld/centerInfoDelete.do', {
					centerCd: centerCd
				},
				null,
				function(json) {
					toastr.success(json.message);
					fnCenterSearch(1);
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
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