<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.Date" %>
<link rel="stylesheet" href="/resources/jqgrid/src/css/ui.jqgrid.css">
<script type="text/javascript" src="/resources/jqgrid/js/jquery.jqGrid.min.js"></script>
<c:set var="fSearchDate" value="<%=new Date(new Date().getTime() - 60*60*24*1000*1)%>"/>

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
	<!--contents-->
	<div class="boardlist">
		<div class="whiteBox searchBox">
			<div class="sName">
				<h3>검색 옵션</h3>
			</div>
          	
          	<div class="top">
				<p>지점</p>
				<select id="searchCenterCd">
					<option value="">지점 선택</option>
					<c:forEach items="${centerList}" var="centerList">
						<option value="${centerList.center_cd}"><c:out value='${centerList.center_nm}'/></option>
					</c:forEach>
				</select>
				
				<p>기간</p>
				<p>
				<input type="text" id="searchResvDateFrom" class="cal_icon" name="date_from" value=<fmt:formatDate value="${fSearchDate}" pattern="yyyyMMdd" /> autocomplete=off style="width:110px;">~
				<input type="text" id="searchResvDateTo" class="cal_icon" name="date_from" value=<fmt:formatDate value="${fSearchDate}" pattern="yyyyMMdd" /> autocomplete=off style="width:110px;">
				</p>
          	</div>
          	
          	<div class="inlineBtn">
            	<a href="javascript:fnCenterUsageStatList();" class="grayBtn">검색</a>
          	</div>
        </div>
        <div class="clear"></div>
        
        <div class="tabs blacklist">
          <div class="tab active">지점 별 인원통계</div>
<!--      <div class="tab">지점 별 이용통계</div>
          <div class="tab">지점 별 연령대 통계</div> -->
        </div>
		<div class="clear"></div>
        
        <div class="whiteBox">
			<table class="main_table dashboard">
           		<thead class="active">
	            	<tr>
	            		<th></th>
	            		<th colspan="2">지점인원</th>
	            		<th colspan="4">회원</th>
	            		<th colspan="4">비회원</th>
	            		<th colspan="3">합계(회원+비회원)</th>
	            		<th colspan="3">통합</th>
	            	</tr>
	            	<tr>
	            		<th>일자</th>
			            <th>지점명</th>
			            <th>예약정원</th>
			            <th>예약</th>
			            <th>입장완료</th>
			            <th>예약취소</th>
			            <th>예약 이행률</th>
			            <th>예약</th>
			            <th>입장완료</th>
			            <th>예약취소</th>
			            <th>예약 이행률</th>
			            <th>예약</th>
			            <th>입장완료</th>
			            <th>예약취소</th>
			            <th>이행률</th>
			            <th>위약률</th>
			            <th>지점가동률</th>                                
	            	</tr>
            	</thead>
            	<tbody class="active">
                   
            	</tbody>
			</table>
		</div>     
	</div>
</div>
<!-- contents//-->
<!-- //popup -->
<!-- popup// -->
<script type="text/javascript">
	$(document).ready(function() {
		$("#searchResvDateFrom").datepicker(EgovCalendar);
		$("#searchResvDateTo").datepicker(EgovCalendar);
		fnCenterUsageStatList();
	});

	function fnCenterUsageStatList() {
		if (parseInt($("#searchResvDateFrom").val()) > parseInt($("#searchResvDateTo").val())) {
            toastr.warning('검색종료일자가 시작일자보다 빠를수 없습니다.');
            return;
        }
		
		EgovIndexApi.apiExecuteJson(
			'POST',
			'/backoffice/stt/dashboardByCenterListAjax.do',
			{
				"searchCenterCd" : $("#searchCenterCd").val(),
				"searchResvDateFrom" : $("#searchResvDateFrom").val(),
				"searchResvDateTo" : $("#searchResvDateTo").val()
			},
			null,
			function(json) {
				if (json.status === 'SUCCESS') {
					let $tbody = $(".main_table tbody");
					$tbody.empty();
					
					if(json.usageStatList.length > 1) {
						$.each(json.usageStatList, function (index, item) {
							let isLastIndex = (index === (json.usageStatList.length - 1));
							let tdRow = "";
							let trClass = "";
							
							if(!isLastIndex) {
								tdRow = "<td>" + item.resv_date + "</td>" + 
										"<td>" + item.center_nm + "</td>";	
							} else {
								tdRow = "<td colspan='2'>총계</td>";
								trClass ="tb_bottom";
							}
							
							$tbody.append
							(
								"<tr class='" + trClass + "'>" + tdRow +
									"<td>" + item.seat_all_count + "</td>" +
									"<td>" + item.m_resv_all_count + "</td>" +
									"<td>" + item.m_resv_success_count + "</td>" +
									"<td>" + item.m_resv_cancel_count + "</td>" +
									"<td>" + item.m_resv_success_per + "</td>" +
									"<td>" + item.g_resv_all_count + "</td>" +
									"<td>" + item.g_resv_success_count + "</td>" +
									"<td>" + item.g_resv_cancel_count + "</td>" +
									"<td>" + item.g_resv_success_per + "</td>" +
									"<td>" + item.t_resv_all_count + "</td>" +
									"<td>" + item.t_resv_success_count + "</td>" +
									"<td>" + item.t_resv_cancel_count + "</td>" +
									"<td>" + item.t_resv_success_per + "</td>" +
									"<td>" + item.t_resv_cancel_per + "</td>" +
									"<td>" + item.t_center_use_per + "</td>" +
								"</tr>"
							);
						});
					} else {
						$tbody.append("<tr><td colspan='17'>조회 일자에 데이터가 존재하지 않습니다.</td></tr>");
					}
				}
			},
			function(json) {
				toastr.error(json.status);
			}
		);
	}
</script>