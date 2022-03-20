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
<!-- Xlsx -->
<script type="text/javascript" src="/resources/js/xlsx.full.min.js"></script>
<!-- FileSaver -->
<script src="/resources/js/FileSaver.min.js"></script>
<!-- //contents -->
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>기초 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">휴일 관리</li>
	</ol>
</div>
<h2 class="title">휴일 관리</h2>
<div class="clear"></div>
<div class="dashboard">
	<div class="boardlist">
      	<div class="whiteBox searchBox">
            <div class="top">
            	<p>기간</p>
	            <input type="text" id="searchFrom" class="cal_icon" numberonly> ~
	            <input type="text" id="searchTo" class="cal_icon" numberonly>
                <p>검색어</p>
                <input type="text" id="searchKeyword" placeholder="검색어를 입력하새요.">
            </div>
            <div class="inlineBtn">
                <a href="javascript:fnSearch(1);" class="grayBtn">검색</a>
            </div>
        </div>
        <div class="left_box mng_countInfo">
          <p>총 : <span id="sp_totcnt"></span>건</p>
        </div>
        <div class="right_box">
        	<a href="javascript:fnHolyInfoCenterApply();" class="blueBtn">전체지점 휴일 등록</a>
        	<a href="javascript:$('[data-popup=bas_excel_upload]').bPopup();" class="blueBtn">엑셀 업로드</a>
        	<a href="javascript:fnExcelDownload();" class="blueBtn">엑셀 다운로드</a>
        	<a href="javascript:fnHolyInfo();" class="blueBtn">휴일 등록</a>
        	<a href="javascript:fnHolyDelete();" class="grayBtn">삭제</a>
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
<!-- 휴일 정보 팝업 -->
<div data-popup="bas_holiday_add" class="popup m_pop">
	<div class="pop_con">
		<a class="button b-close">X</a>
    	<h2 class="pop_tit">휴일 정보 등록</h2>
    	<div class="pop_wrap">
    		<form>
    		<input type="hidden" name="mode" value="Ins">
    		<input type="hidden" name="holySeq">
    		<table class="detail_table">
           		<tbody>
               		<tr>
						<th>휴일 일자</th>
	                    <td>
	                    	<input type="text" name="holyDt" class="cal_icon" style="margin-top:4px;">
	                    	<span id="sp_Unqi">
                            	<a href="javascript:fnIdCheck();" class="blueBtn">중복확인</a>
                            	<input type="hidden" id="idCheck" value="N">
                            </span>
	                    </td>
					</tr>
					<tr>
				        <th>휴일명</th>
			            <td>
		                    <input type="text" name="holyNm">
						</td>
					</tr>
					<tr>
						<th>사용 유무</th>
					    <td>
				            <span>
			                    <input type="radio" name="useYn" value="Y">사용</input>
							</span>
						    <span>
					            <input type="radio" name="useYn" value="N">사용안함</input>
			                </span>
		                </td>
	                </tr>
				</tbody>
			</table>
			</form>
			<div id="popCenterList" style="width:570px;display:none;">
				<table id="popGrid"></table>
				<div id="popPager"></div>
			</div>
		</div>
	    <popup-right-button />
	</div>
</div>
<div data-popup="bas_excel_upload" class="popup m_pop">
	<div class="pop_con">
		<a class="button b-close">X</a>
        <p class="pop_tit">엑셀 업로드</p>
        <p class="pop_wrap">
        	<input type="file" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet">
        </p>
        <div style="float:left;margin-top:5px;">
        	<a href="/backoffice/bas/holyInfoUploadSampleDownload.do" class="orangeBtn">샘플</a>
        </div>
        <popup-right-button okText="업로드" />
	</div>
</div>
<!-- popup// -->
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		// 메인 JqGrid 정의
		EgovJqGridApi.mainGrid([
			{ label: '휴일코드', name:'holy_seq', align:'center', hidden: true, key: true },
			{ label: '휴일일자', name:'holy_dt', align:'center', fixed: true },
			{ label: '휴일명', name:'holy_nm', align:'center' },
			{ label: '사용유무', name:'use_yn', align:'center', fixed: true },
			{ label: '지점적용', name:'holy_center_spread', align:'center', fixed: true },
			{ label: '수정자', name: 'last_updusr_id', align:'center', fixed: true },
			{ label: '수정일자', name:'last_updt_dtm', align:'center', fixed: true },
			{ label: '수정', align:'center', width: 50, fixed: true, formatter: (c, o, row) =>
	        	'<a href="javascript:fnHolyInfo(\''+ row.holy_seq +'\');" class="edt_icon"></a>'
	        }
		], true, false, fnSearch);
		// 휴일 적용 센터 JqGrid 정의
		EgovJqGridApi.defaultGrid('popGrid', [
			{ label: '지점코드', name: 'center_cd', key: true, hidden: true },
			{ label: '적용지점', name: 'center_nm', align: 'center', sortable: false },
			{ label: '적용휴일명', name: 'holy_nm', align: 'center', sortable: false }
		], 'popPager');
		// 달력 입력 검색 창 정의				
		let startDate = new Date(new Date().getFullYear(), 0, 1);
		let endDate = new Date(new Date().getFullYear(), 11, 31);
		$('#searchFrom').val($.datepicker.formatDate('yymmdd', startDate))
		$('#searchTo').val($.datepicker.formatDate('yymmdd', endDate));
		// 엑셀업로드
		$('[data-popup=bas_excel_upload] .blueBtn').click(function(e) {
			bPopupConfirm('휴일일자 등록', '엑셀 업로드를 통한 휴일일자 등록을 진행하시겠습니까?', function() {
				let $popup = $('[data-popup=bas_excel_upload]');
				let $input = $popup.find(':file')[0];
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
						'/backoffice/bas/holyInfoExcelUpload.do', {
							data: JSON.stringify(json)	
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
		});
	});
	// 메인 목록 검색
	function fnSearch(pageNo) {
		if ($('#searchFrom').val() === '') {
			toastr.warning('기간 시작일자를 입력하세요.');
			return;
		}
		if ($('#searchTo').val() === '') {
			toastr.warning('기간 종료일자를 입력하세요.');
			return;
		}
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val(),
			searchFrom: $('#searchFrom').val(),
			searchTo: $('#searchTo').val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/bas/holyListAjax.do', params, fnSearch);
	}
	// 메인 상세 팝업 정의
	function fnHolyInfo(rowId) {
		let $popup = $('[data-popup=bas_holiday_add]');
		let $form = $popup.find('form:first');
		if (rowId === undefined || rowId === null) {
			$popup.find('h2:first').text('휴일정보 등록');
			$popup.find('span#sp_Unqi').show();
			$popup.find('#popCenterList').hide();
			$popup.find('button.blueBtn').off('click').click(fnHolyInsert);
			$form.find(':hidden[name=mode]').val('Ins');
			$form.find(':hidden[name=holySeq]').val('');
			$form.find(':text').val('');
			$form.find(':hidden#idCheck').val('N');
			$form.find(':text[name=holyDt]').removeAttr('disabled');
			$form.find(':radio[name=useYn]:first').prop('checked', true);
		}
		else {
			let rowData = EgovJqGridApi.getMainGridRowData(rowId);
			$popup.find('h2:first').text('휴일정보 수정');
			$popup.find('span#sp_Unqi').hide();
			$popup.find('#popCenterList').show();
			$popup.find('button.blueBtn').off('click').click(fnHolyUpdate);
			$form.find(':hidden[name=mode]').val('Edt');
			$form.find(':hidden[name=holySeq]').val(rowData.holy_seq);
			$form.find(':text[name=holyDt]').prop('disabled', true).val(rowData.holy_dt);
			$form.find(':text[name=holyNm]').val(rowData.holy_nm);
			$form.find(':radio[name=useYn][value='+ rowData.use_yn +']').prop('checked', true);
			fnCenterHolyInfoSearch(1);
		}
		$popup.bPopup();
	}
	// 중복 휴일 체크
	function fnIdCheck() {
		let $popup = $('[data-popup=bas_holiday_add]');
		let rowId = $popup.find(':text[name=holyDt]').val();
		if (rowId === '') {
			toastr.warning('휴일일자를 입력해 주세요.');
			return;
		}
		EgovIndexApi.apiExecuteJson(
			'GET',
			'/backoffice/bas/holyDtCheck.do', {
				holyDt: rowId
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
	// 휴일 등록
	function fnHolyInsert() {
		let $popup = $('[data-popup=bas_holiday_add]');
		if ($popup.find(':text[name=holyDt]').val() === '') {
			toastr.warning('휴일일자를 입력해 주세요.');
			return;
		}
		if ($popup.find(':hidden#idCheck').val() !== 'Y') {
			toastr.warning('중복체크가 안되었습니다.');
			return;	
		}
		if ($popup.find(':text[name=holyNm]').val() === '') {
			toastr.warning('휴일명을 입력해 주세요.');
			return;
		}
		bPopupConfirm('휴일일자 등록', '등록 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/holyUpdate.do',
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
	// 휴일 수정
	function fnHolyUpdate() {
		let $popup = $('[data-popup=bas_holiday_add]');
		if ($popup.find(':text[name=holyNm]').val() === '') {
			toastr.warning('휴일명을 입력해 주세요.');
			return;
		}
		let rowId = $popup.find(':text[name=holyDt]').removeAttr('disabled').val();
		bPopupConfirm('휴일일자 수정', '<b>'+ rowId +'</b> 수정 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/holyUpdate.do',
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
	// 휴일 삭제
	function fnHolyDelete() {
		let rowIds = EgovJqGridApi.getMainGridMutipleSelectionIds();
		if (rowIds.length === 0) {
			toastr.warning('목록을 선택해 주세요.');
			return false;
		}
		bPopupConfirm('휴일일자 삭제', '삭제 하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/holyDelete.do', {
					holySeq: rowIds.join(',')
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
	// 휴일 적용 지점 목록
	function fnCenterHolyInfoSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: '5',
			holyDt: $('[data-popup=bas_holiday_add]').find(':text[name=holyDt]').val()
		};
		EgovJqGridApi.defaultGridAjaxPaging('popGrid', '/backoffice/bas/holyCenterListAjax.do', params, fnCenterHolyInfoSearch);
	}
	// 엑셀 다운로드
	function fnExcelDownload() {
		if ($(MainGridSelector).getGridParam("reccount") === 0) {
			toastr.warning('다운받으실 데이터가 없습니다.');
			return;
		}
		let params = {
			pageIndex: '1',
			pageUnit: '1000',
			searchKeyword: $('#searchKeyword').val(),
			searchFrom: $('#searchFrom').val(),
			searchTo: $('#searchTo').val()
		};
		EgovIndexApi.apiExecuteJson(
			'POST',
			'/backoffice/bas/holyListAjax.do', 
			params,
			null,
			function(json) {
				let ret = json.resultlist;
				if (ret.length <= 0) {
					return;
				}
				if (ret.length >= 1000) {
					toastr.info('해당 조회 건수가 1000건이 넘습니다. 엑셀 다운로드 시 1000건에 대한 데이터만 저장됩니다.');
				}
				let excelData = new Array();
				excelData.push(['NO', '휴일일자', '휴일명', '사용유무', '지점적용', '수정자', '수정일자']);
				for (let idx in ret) {
					let arr = new Array();
					arr.push(Number(idx)+1);
					arr.push(ret[idx].holy_dt);
					arr.push(ret[idx].holy_nm);
					arr.push(ret[idx].use_yn);
					arr.push(ret[idx].holy_center_spread);
					arr.push(ret[idx].last_updusr_id);
					arr.push(ret[idx].last_updt_dtm);
					excelData.push(arr);
				}
				let wb = XLSX.utils.book_new();
				XLSX.utils.book_append_sheet(wb, XLSX.utils.aoa_to_sheet(excelData), 'sheet1');
				saveAs(new Blob([EgovIndexApi.s2ab(
					XLSX.write(wb, { bookType: 'xlsx', type: 'binary' })
				)],{ type: 'application/octet-stream' }), '휴일관리.xlsx');
			},
			function(json) {
				toastr.error(json.message);
			}
		);
	}
	// 전체지점 휴일 등록
	function fnHolyInfoCenterApply() {
		let rowIds = EgovJqGridApi.getMainGridMutipleSelectionIds();
		if (rowIds.length === 0) {
			toastr.warning('목록을 선택해 주세요.');
			return false;
		}
		let params = new Array();
		for (let rowId of rowIds) {
			let rowData = EgovJqGridApi.getMainGridRowData(rowId);
			params.push({
				holyDt: rowData.holy_dt,
				holyNm: rowData.holy_nm
			});
		}
		bPopupConfirm('전체지점 휴일 등록', '선택한 휴일을 전체지점에 등록하시겠습니까?', function() {
			EgovIndexApi.apiExecuteJson(
				'POST',
				'/backoffice/bas/holyInfoCenterApply.do', 
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