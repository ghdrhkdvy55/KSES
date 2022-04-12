<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/css/reset.css">
<link rel="stylesheet" href="/resources/css/paragraph_new.css">
<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
<script type="text/javascript" src="/resources/js/backoffice/index.js"></script>
<!-- JQuery UI -->
<link rel="stylesheet" href="/resources/css/jquery-ui.css">
<script type="text/javascript" src="/resources/js/jquery-ui.js"></script>
<script src="/resources/js/front/pinch-zoom.umd.js"></script>
<meta charset="UTF-8">
<title>경륜경정 스마트입장 관리자</title>
</head>
<body>
	<div class="wrapper">
		<div class="header">
			<div class="area_info">
				<img src="/resources/img/logo1.png" width="180px"  alt="">
				<span></span>
			</div>
			<div class="seat_stat">
				<ul>
					<li class="disable"><i></i>신청불가</li>
					<li class="usable"><i></i>신청가능</li>
				</ul>
			</div>			
		</div>
		<div class="contents">

		</div>
	</div>
</body>

<script type="text/javascript">
	let centerCd = '${areaInfo.centerCd}';
	let floorCd  = '${areaInfo.floorCd}';
	let partCd   = '${areaInfo.partCd}';
	
	$(document).ready(function() {
		fnPartInSeatList();
 		setInterval(function() {
			fnPartInSeatList();
		}, 60000);
	});
	
	function fnPartInSeatList() {
		let today = new Date();
		let resvDate = $.datepicker.formatDate('yymmdd', today);
		
		EgovIndexApi.apiExecuteJson(
			'POST',
			'/front/rsvSeatListAjax.do', 
			{
				centerCd : centerCd,
				floorCd : floorCd,
				partCd : partCd,
				resvDate : resvDate
			},
			null,
			function(json) {
				let areaInfo = json.seatMapInfo;
				let areaNm = areaInfo.center_nm + ' ' + areaInfo.floor_nm + ' ' + areaInfo.part_nm + ' ' + areaInfo.part_class_nm;
				let contents = $('.contents');
				contents.empty();
				
				let setHtml = '';
				setHtml += '<div id="gui_seat" class="gui_seat mapbottom pinch-zoom-parent">';
				setHtml += '    <div class="part_map pinch-zoom" style="background-repeat: no-repeat; background-position: center center">';
				setHtml += '        <div class="seat">';
				setHtml += '            <ul id="area_Map">';
				setHtml += '            </ul>';
				setHtml += '        </div>';
				setHtml += '    </div>';
				setHtml += '</div>';
				
				contents.append(setHtml);

   				let el = document.querySelector('.part_map');
				let pinchzoom = new PinchZoom.default(el, {});
				pinchzoom.scaleZoomFactor(1.1);
				pinchzoom.update(); 
				
				$('.area_info > span').html(areaNm);
				
				if (json.seatMapInfo != null) {
			   	    var img = json.seatMapInfo.part_map1;
			   	    $('.part_map').css({
			   	        "background": "#fff url(/upload/" + img + ")",
			   	        'background-repeat': 'no-repeat',
			   	        'background-origin' : 'border-box'
			   	    });
			   	} else {
			   	    $('.part_map').css({
			   	        "background": "#fff url()",
			   	        'background-repeat': 'no-repeat',
						'background-origin' : 'border-box'
			   	    });
			   	}
					
				shtml = '';
				let obj = json.resultlist;
				
 				for (let i in json.resultlist) {
					let addClass = (obj[i].status == "0") ? "seatUse" : "none";
					let onClick = "seatService.fn_seatChange(this);"; 
					shtml += '<li id="' + obj[i].seat_cd + '" class="' + addClass + '" seat-id="' + obj[i].seat_cd + '" name="' + obj[i].seat_nm + '" >' + obj[i].seat_number + '</li>';
				}
	    		    
				$('#area_Map').html(shtml);
	    		    
				for(let i in json.resultlist) {
					$("#" + obj[i].seat_cd).css({
						"top" : obj[i].seat_top + "px",
						"left": obj[i].seat_left + "px"
					});	    		        
				}
			},
			function(json) {
				
			}
		);
	}
</script>

</html>