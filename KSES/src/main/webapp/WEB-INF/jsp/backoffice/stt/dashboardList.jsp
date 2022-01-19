<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- //contents -->
<div class="breadcrumb">
	<ol class="breadcrumb-item">
		<li>통합 관리&nbsp;&gt;&nbsp;</li>
		<li class="active">통합 이용 현황</li>
	</ol>
</div>
<h2 class="title">통합 이용 현황 &nbsp;&nbsp;&nbsp;<span style="color:blue;font-size:14px;">구현중입니다......................................</span></h2>
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
					<p class="txt">0</p>
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
					<p class="txt">0</p>
					<p class="refresh">
						<a href="javascript:void(0);" class="update">
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
					<p class="txt">0</p>
					<p class="refresh">
						<a href="javascript:void(0);" class="update">
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
			<a href="javascript:void(0);" class="right_box blueBtn">엑셀 다운로드</a>
		</div>
		<div class="clear"></div>
		<div class="whiteBox">
			<table class="main_table">
				<thead>
					<th>지점명</th>
					<th>입장정원</th>
					<th>예약인원</th>
					<th>입장인원</th>
					<th>자동취소 인원</th>
					<th>입장률</th>
					<th></th>
				</thead>
				<tbody></tbody>
			</table>
		</div>
		<ul class="page_num">
			<li><a href="javascript:;" class="before2 "></a></li>
			<li><a href="javascript:;" class="before rignt15"></a></li>
			<li class="active"><a href="javascript:;">1</a></li>
			<li><a href="javascript:;" class="after left15"></a></li>
			<li><a href="javascript:;" class="after2"></a></li>
		</ul>
	</div>
</div>
<!-- contents//-->
<!-- //popup -->
<!-- popup// -->
<script type="text/javascript">
	$(document).ready(function() {
		
	});
</script>
