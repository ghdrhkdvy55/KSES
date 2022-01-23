<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
<%--			<a href="javascript:void(0);" class="right_box blueBtn">엑셀 다운로드</a>--%>
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
		fn_Ajax (
			'/backoffice/stt/todayResvNumberAjax.do',
			"POST",
			null,
			false,
			function(result) {
				if (result.status === 'SUCCESS') {
					$('#pResvNumber').text(result.todayResvNumber);
				}
			},
			function(request){
				console.log('error: '+ request.status);
			}
		);
	}

	function fnNowEntryNumber() {
		fn_Ajax (
			'/backoffice/stt/nowEntryNumberAjax.do',
			"POST",
			null,
			false,
			function(result) {
				if (result.status === 'SUCCESS') {
					$('#pNowEntryNumber').text(result.nowEntryNumber);
				}
			},
			function(request){
				console.log('error: '+ request.status);
			}
		);
	}

	function fnDashboardList() {
		fn_Ajax (
			'/backoffice/stt/dashboardListAjax.do',
			"POST",
			null,
			false,
			function(result) {
				if (result.status === 'SUCCESS') {
					let $tbody = $('.main_table tbody');
					$tbody.empty();
					for (let item of result.dashboardList) {
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
				}
			},
			function(request){
				console.log('error: '+ request.status);
			}
		);
	}
</script>
