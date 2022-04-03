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
		<li class="active">시즌 관리</li>
	</ol>
</div>
<h2 class="title">시즌 관리</h2>
<div class="clear"></div>
<div class="dashboard">
	<div class="boardlist">
		<div class="whiteBox searchBox">
			<div class="top">
				<p>지점</p>
				<select id="searchCenter">
					<option value="">전체</option>
					<c:forEach var="item" items="${centerCombo}">
						<option value="${item.center_cd}"><c:out value="${item.center_nm}"/></option>
					</c:forEach>
				</select>
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
			<a href="javascript:fnPopupSeasonInfo();" class="blueBtn">시즌 등록</a>
			<a href="javascript:fnSeasonDelete();" class="grayBtn">삭제</a>
		</div>
		<div class="clear"></div>
		<div class="whiteBox">
			<table id="mainGrid"></table>
			<div id="pager"></div>
		</div>
	</div>
</div>
<div data-popup="bld_season_add" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
		<h2 class="pop_tit">시즌 등록</h2>
		<div class="pop_wrap">
			<form>
				<input type="hidden" name="mode" value="Ins">
				<input type="hidden" name="seasonCd">
				<input type="hidden" name="seasonCenterinfo">
				<table class="detail_table">
					<tbody>
						<tr>
							<th>시즌명</th>
							<td><input type="text" name="seasonNm"></td>
							<th>사용유무</th>
							<td>
								<input type="radio" name="useYn" value="Y">사용</input>
								<input type="radio" name="useYn" value="N">사용 안함</input>
							</td>
						</tr>
						<tr>
							<th>시즌시작일</th>
							<td><input type="text" name="seasonStartDay" class="cal_icon" readonly></td>
							<th>시즌종료일</th>
							<td><input type="text" name="seasonEndDay" class="cal_icon" readonly></td>
						</tr>
						<tr>
							<th>해당지점</th>
							<td colspan="3">
								<c:forEach var="item" items="${centerCombo}">
									<input type="checkbox" name="chkCenterInfo" value="${item.center_cd}"/>
									<c:out value="${item.center_nm}"/>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<th>상세설명</th>
							<td colspan="3">
								<textarea name="seasonDc" style="width:400px;height:150px;"></textarea>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
		<popup-right-button clickFunc="javascript:fnSeasonUpdate();"/>
	</div>
</div>
<nav id="cbp-spmenu-season" class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right"></nav>
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$('#cbp-spmenu-season').load('/backoffice/bld/seasonSeatGui.do');
		// 메인 목록 정의
		EgovJqGridApi.mainGrid([
			{ label: '시즌코드', name: 'season_cd', hidden: true, key: true },
			{ label: '시즌명', name: 'season_nm', align: 'left', width: '200px', fixed: true },
			{ label: '시즌시작일', name: 'season_start_day', fixed: true },
			{ label: '시즌종료일', name: 'season_end_day', fixed: true },
			{ label: '사용유무', name: 'use_yn', fixed: true },
			{ label: '적용지점', name: 'season_centerinfo_nm', align: 'left' },
			{ label: '적용지점코드', name: 'season_centerinfo', hidden: true },
			{ label: '설명', name: 'season_dc', hidden: true },
			{ label: '수정', align:'center', sortable: false, width: 50, fixed: true, formatter: (c, o, row) =>
				'<a href="javascript:fnPopupSeasonInfo(\''+ row.season_cd + '\');" class="edt_icon"></a>'
			},
			{ label: 'GUI', align:'center', sortable: false, width: 50, fixed: true, formatter: (c, o, row) =>
				'<a href="javascript:fnSeasonSeatGuiOpen(\''+row.season_cd+'\');" class="gui_icon"></a>'
			}
		], false, false, fnSearch);
	});
	// 시즌 관리 목록 조회
	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val(),
			searchCenter: $('#searchCenter').val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/bld/seasonListAjax.do', params, fnSearch);
	}
	// 시즌 관리 상세 팝업 호출
	function fnPopupSeasonInfo(rowId) {
		let $popup = $('[data-popup=bld_season_add]');
		let $form = $popup.find('form:first');
		$form.find(':hidden[name=seasonCenterinfo]').val('');
		if (rowId === undefined || rowId === null) {
			let today = new Date();
			$popup.find('h2:first').text('시즌 등록');
			$form.find(':hidden[name=mode]').val('Ins');
			$form.find(':text,textarea').val('');
			$form.find('.cal_icon').val($.datepicker.formatDate('yymmdd', today));
			$form.find(':radio[name=useYn]:first').prop('checked', true);
			$form.find(':checkbox[name=chkCenterInfo]').prop('checked', false);
			if($('#loginCenterCd').val() !== '') {
				fnSeasonCenterCheckbox([$('#loginCenterCd').val()]);
			}
		} else {
			let rowData = EgovJqGridApi.getMainGridRowData(rowId);
			$popup.find('h2:first').text('시즌 수정');
			$form.find(':hidden[name=mode]').val('Edt');
			$form.find(':hidden[name=seasonCd]').val(rowData.season_cd);
			$form.find(':text[name=seasonNm]').val(rowData.season_nm);
			$form.find(':text[name=seasonStartDay]').val(rowData.season_start_day);
			$form.find(':text[name=seasonEndDay]').val(rowData.season_end_day);
			$form.find(':radio[name=useYn][value='+ rowData.use_yn +']').prop('checked', true);
			$form.find('textarea').val(rowData.season_dc);
			$form.find(':checkbox[name=chkCenterInfo]').prop('checked', false);
			fnSeasonCenterCheckbox(rowData.season_centerinfo.split(','));
            EgovJqGridApi.selection('mainGrid', rowId);
		}
		switch ($('#loginAuthorCd').val()) {
			case 'ROLE_ADMIN':
			case 'ROLE_SYSTEM':
				$('tr:eq(2),.blueBtn', $popup).show();
				break;
			default:
				$('tr:eq(2),.blueBtn', $popup).hide();
				if ($(':hidden[name=mode]').val() === 'Ins') {
					$('.blueBtn').show();
				} else if ($(':hidden[name=mode]').val() === 'Edt') {
					$.each($(':checkbox[name=chkCenterInfo]', $popup), function() {
						if ($(this).val() === $('#loginCenterCd').val()) {
							$('.blueBtn').show();
							return false;
						}
					});
				}
		}
		$popup.bPopup();
	}
	// 시즌 관리 저장
	function fnSeasonUpdate() {
		let $popup = $('[data-popup=bld_season_add]');
		if ($popup.find(':text[name=seasonNm]').val() === '') {
			toastr.warning('시즌명을 입력해 주세요.');
			return;
		}
		let seasonStartDay = $popup.find(':text[name=seasonStartDay]').val();
		let seasonEndDay = $popup.find(':text[name=seasonEndDay]').val();
		if (seasonStartDay === '') {
			toastr.warning('시즌시작일을 선택해 주세요.');
			return;
		}
		if (seasonEndDay === '') {
			toastr.warning('시즌종료일을 선택해 주세요.');
			return;
		} else {
			if (seasonStartDay > seasonEndDay) {
				toastr.warning('시즌종료일이 시즌시작일보다 빠릅니다.');
				return;
			}
		}
		if ($popup.find(':checkbox[name=chkCenterInfo]:checked').length === 0) {
			toastr.warning('시즌을 사용할 지점을 선택 하지 않았습니다.');
			return;
		} else {
			$.each($(':checkbox[name=chkCenterInfo]:checked', $popup), function() {
				let seasonCenterinfo = $(':hidden[name=seasonCenterinfo]').val();
				if (seasonCenterinfo === '') {
					$(':hidden[name=seasonCenterinfo]').val($(this).val());
				} else {
					$(':hidden[name=seasonCenterinfo]').val(seasonCenterinfo+','+$(this).val());
				}
			});
		}
		bPopupConfirm('시즌정보 저장', '저장 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bld/seasonInfoUpdate.do',
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
	// 시즌 관리 삭제
	function fnSeasonDelete() {
		let $popup = $('[data-popup=bld_season_add]');
		let rowId = EgovJqGridApi.getMainGridSingleSelectionId();
		if (rowId === null) {
			toastr.warning('목록을 선택해 주세요.');
			return false;
		}
		bPopupConfirm('시즌정보 삭제', '삭제 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bld/seasonInfoDelete.do', {
					seasonCd: rowId
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
	// 시즌 해당 지점 체크
	function fnSeasonCenterCheckbox(arr) {
		let $popup = $('[data-popup=bld_season_add]');
		arr.forEach(x => $(':checkbox[name=chkCenterInfo][value='+x+']', $popup).prop('checked', true));
	}
	// 시즌 좌석 GUI 화면
	function fnSeasonSeatGuiOpen(seasonCd) {
		SeasonSeatGui.initialize(seasonCd);
	}
</script>