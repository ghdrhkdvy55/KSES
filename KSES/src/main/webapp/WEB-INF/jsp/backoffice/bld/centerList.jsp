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
<link rel="stylesheet" href="/resources/css/backoffice/cbp-spmenu.css">
<script type="text/javascript" src="/resources/js/classie.js"></script>
<!-- //contents -->
<input type="hidden" id="floorCd">
<input type="hidden" id="partCd">
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
					<a href="javascript:fnPopupBillInfo();" class="blueBtn">현금영수증 설정</a>
					<a href="javascript:fnPopupCenterInfo();" class="blueBtn">지점 등록</a>
					<a href="javascript:fnCenterRemove();" class="grayBtn">삭제</a>
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
				<b>지점명:</b>&nbsp;<span id="spCenterNm">선택되지 않음</span>
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
<!-- // 복사 지점 휴일 검색 팝업 -->
<div data-popup="bld_holy_copy" class="popup">
	<div class="pop_con">
		<h2 class="pop_tit">휴일 복사</h2>
		<div class="pop_wrap">
			<fieldset class="whiteBox searchBox">
				<div class="top" style="padding:0;border-bottom:none;">
              		<p>지점</p>
              		<select id="holySearchCenterCd">
						<option value="">지점 선택</option>
						<c:forEach items="${centerInfoComboList}" var="centerInfo">
							<option value="${centerInfo.center_cd}"><c:out value='${centerInfo.center_nm}'/></option>
						</c:forEach>
              		</select>
					<a href="javascript:fnHolySearch(1);" class="grayBtn">검색</a>
				</div>
			</fieldset>
			<div style="width:570px;">
				<table id="popGridHolyCopy"></table>
				<div id="popPagerHolyCopy"></div>
			</div>
		</div>
		<popup-right-button okText="복사" clickFunc="fnHolyCopy();" />
	</div>
</div>
<!-- // 복사 지점 휴일 검색 팝업 -->
<div data-popup="bld_preopen_copy" class="popup">
	<div class="pop_con">
		<h2 class="pop_tit">사전 예약 시간 복사</h2>
		<div class="pop_wrap">
			<fieldset class="whiteBox searchBox">
				<div class="top" style="padding:0;border-bottom:none;">
              		<p>지점</p>
              		<select id="preopenSearchCenterCd">
						<option value="">지점 선택</option>
						<c:forEach items="${centerInfoComboList}" var="centerInfo">
							<option value="${centerInfo.center_cd}"><c:out value='${centerInfo.center_nm}'/></option>
						</c:forEach>
              		</select>
					<a href="javascript:fnPreopenSearch(1);" class="grayBtn">검색</a>
				</div>
			</fieldset>
			<div style="width:570px;">
				<table id="popGridPreopenCopy"></table>
				<div id="popPagerPreopenCopy"></div>
			</div>
		</div>
		<popup-right-button okText="복사" clickFunc="fnPreopenCopy();" />
	</div>
</div>
<!-- // 복사 자동 취소 검색 팝업 -->
<div data-popup="bld_noshow_copy" class="popup">
	<div class="pop_con">
		<h2 class="pop_tit">사전 예약 시간 복사</h2>
		<div class="pop_wrap">
			<fieldset class="whiteBox searchBox">
				<div class="top" style="padding:0;border-bottom:none;">
              		<p>지점</p>
              		<select id="noshowSearchCenterCd">
						<option value="">지점 선택</option>
						<c:forEach items="${centerInfoComboList}" var="centerInfo">
							<option value="${centerInfo.center_cd}"><c:out value='${centerInfo.center_nm}'/></option>
						</c:forEach>
              		</select>
					<a href="javascript:fnNoshowSearch(1);" class="grayBtn">검색</a>
				</div>
			</fieldset>
			<div style="width:570px;">
				<table id="popGridNoshowCopy"></table>
				<div id="popPagerNoshowCopy"></div>
			</div>
		</div>
		<popup-right-button okText="복사" clickFunc="fnNoshowCopy();" />
	</div>
</div>
<!-- // 좌석구역 생성 팝업 -->
<div data-popup="bld_seat_add" class="popup">
	<div class="pop_con">
		<a class="button b-close">X</a>
      	<h2 class="pop_tit">구역 좌석 일괄 생성</h2>
      	<div class="pop_wrap">
          	<table class="detail_table">
              	<tbody>
                  	<tr>
                    	<th>설정 범위</th>
                    	<td colspan="3">
                        	<select id="seatStr" name="seatStr">
		                  		<c:forEach var="cnt" begin="1" end="1000" step="1">
		                     		<option value="${cnt}"><c:out value='${cnt}'/></option>
		                  		</c:forEach> 
			             	</select>~
			             	<select id="seatEnd" name="seatEnd">
			                  	<c:forEach var="cnt" begin="1" end="1000" step="1">
			                     	<option value="${cnt}"><c:out value='${cnt}'/></option>
			                  	</c:forEach> 
			             	</select>
                    	</td>
                  	</tr>
              	</tbody>
          	</table>
      	</div>
      	<div class="right_box">
			<a href="javascript:fnSeatUpdate();" class="blueBtn">저장</a>
          	<a href="javascript:void(0);" class="grayBtn b-close">취소</a>
      	</div>
		<div class="clear"></div>
	</div>
</div>
<!-- 엑셀 업로드 팝업 -->
<div data-popup="bld_excel_upload" class="popup m_pop">
	<div class="pop_con">
		<a class="button b-close">X</a>
        <p class="pop_tit">엑셀 업로드</p>
        <p class="pop_wrap">
        	<input type="file" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet">
        </p>
        <div style="float:left;margin-top:5px;">
        	<a href="/backoffice/bas/holyInfoUploadSampleDownload.do" class="orangeBtn">샘플</a>
        </div>
        <popup-right-button okText="업로드" clickFunc="fnExcelUpload();" />
	</div>
</div>
<div data-popup="bld_centerinfo_add" class="popup"></div>
<div data-popup="bld_billinfo_add" class="popup"></div>
<div data-popup="bld_floorinfo_add" class="popup"></div>
<div data-popup="bld_partinfo_add" class="popup"></div>
<nav id="cbp-spmenu-floor" class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right"></nav>
<nav id="cbp-spmenu-part" class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right"></nav>
<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	let MainGridAjaxUrl = '';
	$(document).ready(function() {
        // 외부 팝업 load
		$('[data-popup=bld_centerinfo_add]').load('/backoffice/bld/centerInfoPopup.do');
		$('[data-popup=bld_billinfo_add]').load('/backoffice/bld/billInfoPopup.do');
		$('[data-popup=bld_floorinfo_add]').load('/backoffice/bld/floorInfoPopup.do');
		$('[data-popup=bld_partinfo_add]').load('/backoffice/bld/partInfoPopup.do');
		$('#cbp-spmenu-floor').load('/backoffice/bld/floorGui.do');
		$('#cbp-spmenu-part').load('/backoffice/bld/partGui.do');
		// 지점 JqGrid 정의
		EgovJqGridApi.pagingGrid('centerGrid', [
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
            	'<a href="javascript:fnPopupCenterInfo(\''+ row.center_cd +'\',\''+ row.center_nm +'\');" class="edt_icon"></a>'
            }
		], 'centerPager', [10, 20], false).jqGrid('setGridParam', {
			onSelectRow: function(rowId, status, e) {
				if ($(MainGridSelector).contents().length > 0) {
					fnSearch(1);
				}
				let rowData = EgovJqGridApi.getGridRowData('centerGrid', rowId);
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
			let rowId = EgovJqGridApi.getGridSelectionId('centerGrid');
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
				$(MainGridSelector).editCell(0, 0, false);
			});
		});
		setTimeout(function() {
			fnCenterSearch(1);
		}, _JqGridDelay);
		
		Holyday.holyGridSetting();
		Preopen.preopenGridSetting();
		Noshow.noshowGridSetting();
	});
	// 지점 목록 검색
	function fnCenterSearch(pageNo) {
		$('#spCenterNm').text('선택되지 않음');
		let params = {
			pageIndex: pageNo,
			pageUnit: $('#centerPager .ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val()
		};
		EgovJqGridApi.pagingGridAjax('centerGrid', '/backoffice/bld/centerListAjax.do', params, fnCenterSearch);
	}
	// 지점 삭제
	function fnCenterRemove() {
		let rowId = EgovJqGridApi.getGridSelectionId('centerGrid');
		if (rowId === null) {
			toastr.warning('지점 목록을 선택하세요.');
			return;
		}
		let rowData = EgovJqGridApi.getGridRowData('centerGrid', rowId);
		bPopupConfirm('지점 삭제', '<b>'+ rowData.center_nm +'</b> 를(을) 삭제하시겠습니까?', function() {
			bPopupConfirm('지점 삭제', '<b>'+ rowData.center_nm +'</b> 를(을) 삭제하시면 시스템에 영향이 있을 수 있습니다.<br>정말로 삭제하시겠습니까?', function() {
				EgovIndexApi.apiExecuteJson(
						'POST',
						'/backoffice/bld/centerInfoDelete.do', {
							centerCd: rowId
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
		let rowId = EgovJqGridApi.getGridSelectionId('centerGrid');
		let params = {
			pageIndex: pageNo,
			pageUnit: $('#pager .ui-pg-selbox option:selected').val(),
			centerCd: rowId
		};
		if ($('div.tabs .tab.active').attr('id') === 'floor') {
			EgovJqGridApi.mainGridAjax(MainGridAjaxUrl, params, fnSearch, Floor.subFloorPartGrid);
			PartInfo.partClassComboList(rowId);
		} else {
			EgovJqGridApi.mainGridAjax(MainGridAjaxUrl, params, fnSearch);
		}
	}
	// 오른쪽 탭 목록 수정 저장
	function fnRightAreaSave() {
		let tabMenu = $('div.tabs .tab.active').attr('id');
		let changedArr = $(MainGridSelector).jqGrid('getChangedCells', 'all');
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
	// 지점 팝업 호출
	function fnPopupCenterInfo(rowId, name) {
		CenterInfo.bPopup(rowId, name);
	}
	// 현금영수증 팝업 호출
	function fnPopupBillInfo() {
		let rowId = EgovJqGridApi.getGridSelectionId('centerGrid');
		if (rowId === null) {
			toastr.info('지점을 선택해주세요.');
			return;
		}
		let rowData = EgovJqGridApi.getGridRowData('centerGrid', rowId);
		BillInfo.bPopup(rowId, rowData.center_nm);
	}
	// 지점 휴일 목록 조회
	function fnHolySearch(pageNo) {
		let params = {			
				pageIndex: pageNo,
				pageUnit: '10',
				centerCd: $('#holySearchCenterCd').val()
			};
		EgovJqGridApi.pagingGridAjax('popGridHolyCopy', '/backoffice/bld/centerHolyInfoListAjax.do', params, fnHolySearch);	
	}
	
	// 지점 휴일 복사 팝업 호출
	function fnCenterHolyPopup() {
		let rowId = EgovJqGridApi.getGridSelectionId('centerGrid');
		$('#holySearchCenterCd').val(rowId);
		fnHolySearch(1);
		setTimeout(function() {
			$('[data-popup=bld_holy_copy]').bPopup();	
		}, 100);
	}
	// 지점 휴일 복사
	function fnHolyCopy() {
		let rowId = EgovJqGridApi.getGridSelectionId('centerGrid');
		let rowData = EgovJqGridApi.getGridRowData('centerGrid', rowId);
		bPopupConfirm('지점 복사', rowData.center_nm +'지점 에 붙여 넣겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bld/centerHolyInfoCopy.do',
				{
					copyCenterCd : $('#holySearchCenterCd').val(),
					centerCd : rowId
				},
				null,
				function(json) {
					toastr.success(json.message);
					fnSearch(1);
					$('[data-popup=bld_holy_copy]').bPopup().close();
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	
	// 사전 예약 시간 목록 조회
	function fnPreopenSearch(pageNo) {
		let params = {			
				pageIndex: pageNo,
				pageUnit: '10',
				centerCd: $('#preopenSearchCenterCd').val()
			};
		EgovJqGridApi.pagingGridAjax('popGridPreopenCopy', '/backoffice/bld/preOpenInfoListAjax.do', params, fnPreopenSearch);	
	}
	
	// 사전 예약 시간 팝업 호출
	function fnCenterPreopenPopup() {
		let rowId = EgovJqGridApi.getGridSelectionId('centerGrid');
		$('#preopenSearchCenterCd').val(rowId);
		fnPreopenSearch(1);
		setTimeout(function() {
			$('[data-popup=bld_preopen_copy]').bPopup();	
		}, 100);
	}
	// 지점 사전 예약 시간 복사
	function fnPreopenCopy() {
		let rowId = EgovJqGridApi.getGridSelectionId('centerGrid');
		let rowData = EgovJqGridApi.getGridRowData('centerGrid', rowId);
		bPopupConfirm('지점 사전 예약 시간 복사', rowData.center_nm +'지점 에 붙여 넣겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bld/preOpenInfoCopy.do',
				{
					copyCenterCd : $('#preopenSearchCenterCd').val(),
					centerCd : rowId
				},
				null,
				function(json) {
					toastr.success(json.message);
					fnSearch(1);
					$('[data-popup=bld_preopen_copy]').bPopup().close();
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	// 자동 취소 시간 목록 조회
	function fnNoshowSearch(pageNo) {
		let params = {			
				pageIndex: pageNo,
				pageUnit: '10',
				centerCd: $('#noshowSearchCenterCd').val()
			};
		EgovJqGridApi.pagingGridAjax('popGridNoshowCopy', '/backoffice/bld/noshowInfoListAjax.do', params, fnNoshowSearch);	
	}
	
	// 자동 취소 시간 팝업 호출
	function fnCenterNoshowPopup() {
		let rowId = EgovJqGridApi.getGridSelectionId('centerGrid');
		$('#noshowSearchCenterCd').val(rowId);
		fnNoshowSearch(1);
		setTimeout(function() {
			$('[data-popup=bld_noshow_copy]').bPopup();	
		}, 100);
	}
	// 지점 자동 취소 시간 복사
	function fnNoshowCopy() {
		let rowId = EgovJqGridApi.getGridSelectionId('centerGrid');
		let rowData = EgovJqGridApi.getGridRowData('centerGrid', rowId);
		bPopupConfirm('지점 자동 취소 시간 복사', rowData.center_nm +'지점 에 붙여 넣겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bld/noshowInfoCopy.do',
				{
					copyCenterCd : $('#noshowSearchCenterCd').val(),
					centerCd : rowId
				},
				null,
				function(json) {
					toastr.success(json.message);
					fnSearch(1);
					$('[data-popup=bld_noshow_copy]').bPopup().close();
				},
				function(json) {
					toastr.error(json.message);
				}
			);
		});
	}
	function fnExcelUpload() {
		// 엑셀업로드
		bPopupConfirm('지점 휴일일자 등록', '엑셀 업로드를 통한 휴일일자 등록을 진행하시겠습니까?', function() {
			let $popup = $('[data-popup=bld_excel_upload]');
			let $input = $popup.find(':file')[0];
			let rowId = EgovJqGridApi.getGridSelectionId('centerGrid');
			let reader = new FileReader();
			reader.onload = function() {
				let wb = XLSX.read(reader.result, {type: 'binary'});
				let sheet = wb.Sheets[wb.SheetNames[0]];
				let json = XLSX.utils.sheet_to_json(sheet);
				for (let row of json) {
					Object.keys(row).forEach(k => {
						switch (k) {
							case '휴일일자':
								row['holyDt'] = row[k];
								break;
							case '휴일명':
								row['holyNm'] = row[k]
								break;
							case '사용여부':
								row['useYn'] = row[k];
								break;
							default:
						}
						delete row[k];
					});
				}
				EgovIndexApi.apiExecuteJson(
					'POST',
					'/backoffice/bld/centerHolyInfoExcelUpload.do', {
						data: JSON.stringify(json),
						centerCd: rowId
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
			};
			reader.readAsBinaryString($input.files[0]);
		});
	}
	
    //좌석 정보 업데이트
	function fnSeatUpdate() {
		if ($("#seatStr").val() >= $("#seatEnd").val()){
			toastr.warning("시작이 종료 보다 클수 없습니다. ");
			return;
		}
 	    EgovIndexApi.apiExecuteJson(
			'POST',
			'/backoffice/bld/floorSeatUpdate.do',
			{
				floorCd: $("#floorCd").val(),
				partCd: $("#partCd").val(),
				seatStr: $("#seatStr").val(),
				seatEnd: $("#seatEnd").val()
			},
			null,
			function(json) {
				toastr.info(json.message);
				fnSearch(1);
				$('[data-popup=bld_seat_add]').bPopup().close();
				PartGui.open();
				$("#seatStr").val('1');
				$("#seatEnd").val('1');
			},
			function(json) {
			    toastr.error(json.message);
			}
		); 
	}
    
</script>
<script type="text/javascript" src="/resources/js/backoffice/bld/centerList.preopen.js"></script>
<script type="text/javascript" src="/resources/js/backoffice/bld/centerList.noshow.js"></script>
<script type="text/javascript" src="/resources/js/backoffice/bld/centerList.holyday.js"></script>
<script type="text/javascript" src="/resources/js/backoffice/bld/centerList.billday.js"></script>
<script type="text/javascript" src="/resources/js/backoffice/bld/centerList.floor.js"></script>