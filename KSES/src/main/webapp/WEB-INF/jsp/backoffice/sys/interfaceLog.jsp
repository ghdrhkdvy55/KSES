<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=no;" />
    <title>경륜경정 스마트입장 관리자</title>
    <link rel="stylesheet" href="/resources/css/reset.css">
	<link rel="stylesheet" href="/resources/css/paragraph.css">
    <link rel="stylesheet" href="/resources/css/common.css">
    <link rel="stylesheet" href="/resources/css/toggle.css">
    <script src="/resources/js/jquery-3.5.1.min.js"></script>
    <script src="/resources/js/bpopup.js"></script>
    
    <link rel="stylesheet" type="text/css" href="/resources/css/jquery-ui.css">
    <link rel="stylesheet" type="text/css" href="/resources/jqgrid/src/css/ui.jqgrid.css">
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
</head>
<body>
<div class="wrapper">
  <!--// header -->
  <c:import url="/backoffice/inc/top_inc.do" />
  <!-- header //-->
  <!--// contents-->
  <div id="contents">
    <div class="breadcrumb">
      <ol class="breadcrumb-item">
        <li>기초 관리</li>
        <li class="active">　> 권한 관리</li>
      </ol>
    </div>

    <h2 class="title">권한 관리</h2><div class="clear"></div>
    <!--// dashboard -->
    <div class="dashboard">
        <!--contents-->
        <div class="boardlist">
            <div class="left_box mng_countInfo">
                <p>총 : <span id="sp_totcnt"></span>건</p>
                
            </div>
            <a data-popup-open="bas_auth_add" class="right_box blueBtn">권한분류추가</a>  
            <div class="clear"></div>
            <div class="whiteBox">
                <table id="mainGrid"></table>
                <div id="pager" class="scroll" style="text-align:center;"></div>  
            </div>
            
        </div>

    </div>
    
  </div>
  <!-- contents//-->
</div>
<!-- wrapper_end-->
<!-- popup -->
<!--권한분류 추가 팝업-->
<div data-popup="bas_auth_add" class="popup m_pop">
    <div class="pop_con">
        <a class="button b-close">X</a>
        <h2 class="pop_tit">권한 분류 추가</h2>
        <div class="pop_wrap">
            <table class="detail_table">
                <tbody>
                    <tr>
                        <th>권한 코드</th>
                        <td>
                            <input type="text">
                            <a href="" class="blueBtn">중복확인</a>
                        </td>
                    </tr>
                    <tr>
                        <th>권한명</th>
                        <td>
                            <input type="text">
                        </td>
                    </tr>
                    <tr>
                        <th>상세설명</th>
                        <td>
                            <input type="text">
                        </td>
                    </tr>
                    <tr>
                        <th>사용 유무</th>
                        <td>
                            <span>
                                <input type="radio" value="y" id="y">
                                <label for="y">사용</label>
                            </span>
                            <span>
                                <input type="radio" value="n" id="n">
                                <label for="n">사용 안함</label>
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="right_box">
            <a href="" class="grayBtn">취소</a>
            <a href="" class="blueBtn">저장</a>
        </div>
        <div class="clear"></div>
    </div>
</div>
     <c:import url="/backoffice/inc/popup_common.do" />
    <script type="text/javascript" src="/resources/js/common.js"></script>
    <script type="text/javascript" src="/resources/js/back_common.js"></script>
</body>
</html>