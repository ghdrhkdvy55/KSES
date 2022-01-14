<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="common_popup" class="popup">
  <div class="common_pop_con rsv_popup">
      <div class="pop_wrap">
          <h4><img src="/resources/img/front/done.svg" alt="예약완료">예약이 완료 되었습니다.</h4>
      </div>
      <div class="common_pop_btn">
          <a href="javascript:$('#common_popup').bPopup().close();" class="mintBtn">예약내역 확인</a>
      </div>
      <div class="clear"></div>
  </div>
</div>

<script type="text/javascript">
	function fn_openPopup(resultMessage, messageColor, imgDvsn, btnMessage, btnHref) {
		var imgSrc = "";
		var btnHref = btnHref != "" ? btnHref : "javascript:$('#common_popup').bPopup().close();";
		
		messageColor = messageColor == "red" ? "#ff3434" : "#4880e7";
		
		switch(imgDvsn) { 
			case "ERROR" : imgSrc = "<img src='/resources/img/front/ic_textfield_error.svg'>"; break;
			case "SUCCESS" : imgSrc = "<img src='/resources/img/front/ic_approval.svg'>"; break;
			default : imgSrc = "<img src='/resources/img/front/done.svg'>"; break;
		}
		
		$("#common_popup").bPopup();
		$("#common_popup h4").html("").css("color", messageColor);
		$("#common_popup h4").html(imgSrc + resultMessage);
		$("#common_popup a").html(btnMessage);
		$("#common_popup a").attr("href",btnHref);
		
   	}
</script>