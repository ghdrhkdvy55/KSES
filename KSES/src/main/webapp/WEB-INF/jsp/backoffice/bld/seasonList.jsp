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
			<a href="javascript:void(0);" class="grayBtn">삭제</a>
		</div>
		<div class="clear"></div>
		<div class="whiteBox">
			<table id="mainGrid"></table>
			<div id="pager"></div>
		</div>
	</div>
</div>
<div data-popup="bld_season_add" class="popup"></div>
<script type="text/javascript" src="/resources/jqgrid/jqgrid.custom.egovapi.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		// 외부 팝업 load
		$('[data-popup=bld_season_add]').load('/backoffice/bld/seasonInfoPopup.do');
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
				'<a href="javascript:void(0);" class="edt_icon"></a>'
			},
			{ label: 'GUI', align:'center', sortable: false, width: 50, fixed: true, formatter: (c, o, row) =>
				'<a href="javascript:void(0);" class="gui_icon"></a>'
			}
		], false, false, fnSearch);
	});

	function fnSearch(pageNo) {
		let params = {
			pageIndex: pageNo,
			pageUnit: $('.ui-pg-selbox option:selected').val(),
			searchKeyword: $('#searchKeyword').val(),
			searchCenter: $('#searchCenter').val()
		};
		EgovJqGridApi.mainGridAjax('/backoffice/bld/seasonListAjax.do', params, fnSearch);
	}

	function fnPopupSeasonInfo() {
		$('[data-popup=bld_season_add]').bPopup();
	}
</script>