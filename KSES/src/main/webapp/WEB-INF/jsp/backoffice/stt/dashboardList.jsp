<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Xlsx -->
<script type="text/javascript" src="/resources/js/xlsx.full.min.js"></script>
<!-- FileSaver -->
<script src="/resources/js/FileSaver.min.js"></script>
<!-- //contents -->
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>통합 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">통합 이용 현황</li>
	</ol>
</div>
<h2 class="title">통합 이용 현황</h2>
<div class="clear"></div>
<div class="dashboard">
	<!-- 실시간 현황 -->
	<div class="row">
		<div class="lg-4">
			<div class="dash_box">
				<div class="icon_con icon_seat">
					<i></i>
				</div>
				<div class="dash_txt">
					<p class="tit">금일 입장 정원</p>
					<p class="txt"><c:out value="${entryMaximumNumber}"/></p>
				</div>
			</div>
		</div>
		<div class="lg-4">
			<div class="dash_box">
				<div class="icon_con icon_meeting">
					<i></i>
				</div>
				<div class="dash_txt">
					<p class="tit">총 예약 인원</p>
					<p id="pResvNumber" class="txt">0</p>
					<p class="refresh">
						<a href="javascript:fnTodayResvNumber();" class="update">
							<img src="/resources/img/refresh.svg" alt="업데이트">업데이트
						</a>
					</p>
				</div>
			</div>
		</div>
		<div class="lg-4">
			<div class="dash_box">
				<div class="icon_con icon_visit">
					<i></i>
				</div>
				<div class="dash_txt">
					<p class="tit">현재 입장 인원</p>
					<p id="pNowEntryNumber" class="txt">0</p>
					<p class="refresh">
						<a href="javascript:fnNowEntryNumber();" class="update">
							<img src="/resources/img/refresh.svg" alt="업데이트">업데이트
						</a>
					</p>
				</div>
			</div>
		</div>
		<div class="clear"></div>
	</div>
	<!-- 전일자 현황 -->
	<div class="boardlist">
		<div class="right_box">
			<a href="javascript:fnExcelDownload();" class="right_box blueBtn">엑셀 다운로드</a>
		</div>
		<div class="clear"></div>
		<div class="whiteBox">
			<table class="main_table">
				<thead>
					<th>지점명</th>
					<th>노블레스</th>
					<th>프리미엄</th>
					<th>스탠다드</th>
					<th>일반</th>
					<th>입석</th>
					<th>입장인원</th>
					<th>입장정원</th>
				</thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</div>
<!-- contents//-->
<!-- //popup -->
<!-- popup// -->
<script type="text/javascript">
	$(document).ready(function() {
		fnTodayResvNumber();
		fnNowEntryNumber();
		fnDashboardList();
	});

	function fnTodayResvNumber() {
		EgovIndexApi.apiExecuteJson(
			'POST',
			'/backoffice/stt/todayResvNumberAjax.do',
			null,
			null,
			function(json) {
				if (json.status === 'SUCCESS') {
					$('#pResvNumber').text(json.todayResvNumber);
				}
			},
			function(json) {
				toastr.error(json.status);
			}
		);
	}

	function fnNowEntryNumber() {
		EgovIndexApi.apiExecuteJson(
			'POST',
			'/backoffice/stt/nowEntryNumberAjax.do',
			null,
			null,
			function(json) {
				if (json.status === 'SUCCESS') {
					$('#pNowEntryNumber').text(json.nowEntryNumber);
				}
			},
			function(json) {
				toastr.error(json.status);
			}
		);
	}

	function fnDashboardList() {
		EgovIndexApi.apiExecuteJson(
			'POST',
			'/backoffice/stt/dashboardListAjax.do',
			null,
			null,
			function(json) {
				if (json.status === 'SUCCESS') {
					let $tbody = $('.main_table tbody');
					$tbody.empty();
					for (let item of json.dashboardList) {
						$(	'<tr>'+
								'<td>'+ item.center_nm +'</td>'+
								'<td>'+ item.class_4 +'</td>'+
								'<td>'+ item.class_3 +'</td>'+
								'<td>'+ item.class_2 +'</td>'+
								'<td>'+ item.class_1 +'</td>'+
								'<td>'+ item.stand +'</td>'+
								'<td>'+ item.entry_number +'</td>'+
								'<td>'+ item.maximum_number +'</td>'+
							'</tr>'
						).data('item', item).appendTo($tbody);
					}
					$tbody.find('tr:last').addClass('tb_bottom');
				}
			},
			function(json) {
				toastr.error(json.status);
			}
		);
	}
	
	// 엑셀 다운로드
	function fnExcelDownload() {
		EgovIndexApi.apiExecuteJson(
			'POST',
			'/backoffice/stt/dashboardListAjax.do', 
			null,
			null,
			function(json) {
				let ret = json.dashboardList;
				if (ret.length <= 0) {
					return;
				}
				if (ret.length >= 1000) {
					toastr.info('해당 조회 건수가 1000건이 넘습니다. 엑셀 다운로드 시 1000건에 대한 데이터만 저장됩니다.');
				}
				let excelData = new Array();
				excelData.push(['지점명', '노블레스', '프리미엄', '스탠다드', '일반', '입석', '입장인원', '입장정원']);
				for (let idx in ret) {
					let arr = new Array();
					arr.push(ret[idx].center_nm);
					arr.push(ret[idx].class_4);
					arr.push(ret[idx].class_3);
					arr.push(ret[idx].class_2);
					arr.push(ret[idx].class_1);
					arr.push(ret[idx].stand);
					arr.push(ret[idx].entry_number);
					arr.push(ret[idx].maximum_number);
					excelData.push(arr);
				}
				let wb = XLSX.utils.book_new();
				XLSX.utils.book_append_sheet(wb, XLSX.utils.aoa_to_sheet(excelData), 'sheet1');
				saveAs(new Blob([EgovIndexApi.s2ab(
					XLSX.write(wb, { bookType: 'xlsx', type: 'binary' })
				)],{ type: 'application/octet-stream' }), '통합이용현황.xlsx');
			},
			function(json) {
				toastr.error(json.message);
			}
		);
	}
</script>
