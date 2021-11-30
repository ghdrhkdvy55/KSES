function CustomSelectBox(selector) {
    this.$selectBox = null,
        this.$select = null,
        this.$list = null,
        this.$listLi = null;
    CustomSelectBox.prototype.init = function(selector) {
        this.$selectBox = $(selector);
        this.$select = this.$selectBox.find('.box .select');
        this.$list = this.$selectBox.find('.box .list');
        this.$listLi = this.$list.children('li');
    }
    CustomSelectBox.prototype.initEvent = function(e) {
        var that = this;
        this.$select.on('click', function(e) {
            that.listOn();
        });
        this.$listLi.on('click', function(e) {
            that.listSelect($(this));
        });
        $(document).on('click', function(e) {
            that.listOff($(e.target));
        });
    }
    CustomSelectBox.prototype.listOn = function() {
        this.$selectBox.toggleClass('on');
        if (this.$selectBox.hasClass('on')) {
            this.$list.css('display', 'block');
        } else {
            this.$list.css('display', 'none');
        };
    }
    CustomSelectBox.prototype.listSelect = function($target) {
        $target.addClass('selected').siblings('li').removeClass('selected');
        this.$selectBox.removeClass('on');
        this.$select.text($target.text());
        this.$list.css('display', 'none');
    }
    CustomSelectBox.prototype.listOff = function($target) {
        if (!$target.is(this.$select) && this.$selectBox.hasClass('on')) {
            this.$selectBox.removeClass('on');
            this.$list.css('display', 'none');
        };
    }
    this.init(selector);
    this.initEvent();
}

//facility icon effect
function toilet_men() {
    document.getElementById("toilet_men1").style.display = "block";
    document.getElementById("toilet_men2").style.display = "block";
    document.getElementById("toilet_girl1").style.display = "none";
    document.getElementById("toilet_girl2").style.display = "none";
    document.getElementById("toilet_ele1").style.display = "none";
    document.getElementById("toilet_ele2").style.display = "none";
    document.getElementById("toilet_ele3").style.display = "none";
}
//facility icon effect
function toilet_girl() {
    document.getElementById("toilet_girl1").style.display = "block";
    document.getElementById("toilet_girl2").style.display = "block";

    document.getElementById("toilet_men1").style.display = "none";
    document.getElementById("toilet_men2").style.display = "none";
    document.getElementById("toilet_ele1").style.display = "none";
    document.getElementById("toilet_ele2").style.display = "none";
    document.getElementById("toilet_ele3").style.display = "none";
}
//facility icon effect
function toilet_ele() {
    document.getElementById("toilet_ele1").style.display = "block";
    document.getElementById("toilet_ele2").style.display = "block";
    document.getElementById("toilet_ele3").style.display = "block";

    document.getElementById("toilet_men1").style.display = "none";
    document.getElementById("toilet_men2").style.display = "none";
    document.getElementById("toilet_girl1").style.display = "none";
    document.getElementById("toilet_girl2").style.display = "none";
}
//leftMenu _ gnb
function openNav() {
    document.getElementById("mySidenav").style.display = "block";
    document.getElementById("mySidenav").style.width = "100%";
    document.getElementById("mySidenav1").style.width = "280px";
    document.getElementById("userBox").style.width = "220px";
}

function closeNav() {
    document.getElementById("mySidenav").style.display = "none";
    document.getElementById("mySidenav").style.width = "0";
    document.getElementById("mySidenav1").style.width = "0";
    document.getElementById("userBox").style.width = "0";
}
//rightMenu _ floor
function openRight() {
    document.getElementById("rightMenu").style.width = "100%";
    document.getElementById("rightMenu1").style.width = "280px";
}

function closeRight() {
    document.getElementById("rightMenu").style.width = "0";
    document.getElementById("rightMenu1").style.width = "0";
}
//my reserve
function reserve() {
    document.getElementById("reserve").style.display = "block";
    document.getElementById("reserve_back").style.width = "100%";
    document.getElementById("mySidenav").style.width = "0";
    document.getElementById("mySidenav1").style.width = "0";
}

function closeReserve() {
    document.getElementById("reserve").style.display = "none";
    document.getElementById("reserve_back").style.width = "0";
}
//notice
function notice() {
    document.getElementById("notice").style.display = "block";
    document.getElementById("notice_back").style.width = "100%";
    document.getElementById("mySidenav").style.width = "0";
    document.getElementById("mySidenav1").style.width = "0";
}

function closeNotice() {
    document.getElementById("notice").style.display = "none";
    document.getElementById("notice_back").style.width = "0";
}
//meetingroom search
function meetingView() {
    document.getElementById("meetingView").style.display = "block";
    document.getElementById("meetingView_back").style.width = "100%";
}

function closeMeeting() {
    document.getElementById("meetingView").style.display = "none";
    document.getElementById("meetingView_back").style.width = "0";
}
//reser01_seat timebar
function seatBtn() {
    document.getElementById("seatBtn").style.height = "auto";
}

function closeSeat(obj) {
    $('#' + obj).css('display', 'none');
    var currentDate = new Date();
    $("#reserve_date").datepicker().datepicker("setDate", currentDate);
    $("#area_Map li").siblings().removeClass("select");
}
//reser01_seat reserve info
function seatBtn2() {
    document.getElementById("seatBtn2").style.height = "auto";
}

function closeSeat2() {
    document.getElementById("seatBtn2").style.height = "0";
}



//date
$(document).ready(function() {
    //custom li select
    var _select_title = $(".text_ul_wrap > a");
    $('<div class="select_icon"></div>').insertAfter(_select_title);

    _select_title.click(function() {
        $(".ul_select_style").toggleClass("active");
        $(".select_icon").toggleClass("active");
    });

    $(document).on('click', ".ul_select_style > li", function() {
        var _li_value = $(this).text();
        _select_title = $(this).closest('ul').siblings('a');
        _select_title.text(_li_value);
        var _li_option_value = $(this).attr('value');
        $(".ul_select_style").val(_li_option_value);
        $(".ul_select_style").removeClass("active");
        $(".select_icon").toggleClass("active");
    });

    $("body").click(function(e) {
        if ($(".ul_select_style").hasClass("active")) {
            if (!$(".text_ul_wrap").has(e.target).length) {
                $(".ul_select_style").removeClass("active");
                $(".select_icon").removeClass("active");
            };
        }
    })

    // gnb
    $(".nav_box").on('mouseenter focusin', function() {
        $(".twoDBg").slideDown(300);
        $(".nav_box li .twoD").slideDown(300);
    })
    $(".nav_box").on('mouseleave', function() {
        $(".twoDBg").stop().slideUp(300);
        $(".nav_box li .twoD").stop().slideUp(300);
    })

    // 모바일메뉴
    $('.mobile_gnb_open_btn').click(function() {
        if ($(this).is('.is-active')) {
            $(this).removeClass('is-active');
            $(".mobile_gnb_list").removeClass('on');
            $(".family_link_m").removeClass('on');
            $(".header_wrap .header h1").removeClass('on');
            $("html, body").css({
                "height": "auto",
                "overflow-y": "auto"
            });
            $(".mobile_gnb_list .gnb_area .oneD.depth").eq(mOneDNum).removeClass("on");
            $(".mobile_gnb_list .gnb_area .twoD").eq(mOneDNum).hide();
            mOneDNum = -1;
        } else {
            $(this).addClass('is-active');
            $(".mobile_gnb_list").addClass('on');
            $(".family_link_m").addClass('on');
            $(".header_wrap .header h1").addClass('on');
            $("html, body").css({
                "height": $(window).height(),
                "overflow-y": "hidden"
            });
        };
    });

    var mOneDNum = -1;
    $(".mobile_gnb_list .gnb_area .oneD.depth").each(function(i) {
        $(this).click(function() {
            if (mOneDNum != i) {
                $(".mobile_gnb_list .gnb_area .oneD.depth").eq(mOneDNum).removeClass("on");
                $(".mobile_gnb_list .gnb_area .twoD").eq(mOneDNum).slideUp(300);
                mOneDNum = i;
                $(".mobile_gnb_list .gnb_area .oneD.depth").eq(mOneDNum).addClass("on");
                $(".mobile_gnb_list .gnb_area .twoD").eq(mOneDNum).slideDown(300);
            } else {
                $(".mobile_gnb_list .gnb_area .oneD.depth").eq(mOneDNum).removeClass("on");
                $(".mobile_gnb_list .gnb_area .twoD").eq(mOneDNum).slideUp(300);
                mOneDNum = -1;
            }
        });
    });


    history.pushState(null, null, location.href);
    window.onpopstate = function(event) {
        history.go(-1);
        location.document.reload();
    };

    $("#resultList").on("click", "tr", function() {
        $(this).siblings().removeClass("select");
        $(this).addClass("select");
    });

});

//$(window).ajaxStart(function () {
//  $('.wrap-loading').show();  // 로딩바
//});
//
//$(window).ajaxComplete(function () {
//  $('.wrap-loading').hide();  // 로딩바
//});

// 모바일 메뉴 css변경
jQuery(document).ready(function() {
    var bodyOffset = jQuery('body').offset();
    jQuery(window).scroll(function() {
        if (jQuery(document).scrollTop() > bodyOffset.top) {
            jQuery('header').addClass('scroll');
        } else {
            jQuery('header').removeClass('scroll');
        }
    });
});


function getStr(str) {
    if (str == null || str == 'null') {
        return '';
    } else {
        return str;
    }
}

function getDateTimeForm(param) {
    if (param == null) {
        return '';
    } else {
        return param.substring(0, 4) + '-' + param.substring(4, 6) + '-' + param.substring(6, 8) + ' ' + param.substring(8, 10) + ':' + param.substring(10, 12);
    }
}

function getDateTimeFormFocus(param) {
    if (param == null) {
        return '';
    } else {
        return param.substring(0, 4) + '-' + param.substring(4, 6) + '-' + param.substring(6, 8) + 'T' + param.substring(8, 10) + ':' + param.substring(10, 12);
    }
}

function getDateForm(param) {
    if (param == null) {
        return '';
    } else {
        return param.substring(0, 4) + '-' + param.substring(4, 6) + '-' + param.substring(6, 8);
    }
}

function getDateFormMD(param) {
    if (param == null) {
        return '';
    } else {
        return param.substring(4, 6) + '.' + param.substring(6, 8);
    }
}

function getFormatDateNoBar(date) {
    var year = date.getFullYear(); // yyyy
    var month = (1 + date.getMonth()); // M

    month = parseInt(month) >= 10 ? parseInt(month) : '0' + month; // month 두자리로 저장
    var day = date.getDate(); // d
    day = day >= 10 ? day : '0' + day; // day 두자리로 저장
    return year + '' + month + '' + day;
}

function getPhone(str) {
    var number = '';
    var phone = "";
    if (str != null) {
        number = str.replace(/[^0-9]/g, "");
    } else {
        return '';
    }

    if (number.length < 4) {
        return number;
    } else if (number.length < 7) {
        phone += number.substr(0, 3);
        phone += "-";
        phone += number.substr(3);
    } else if (number.length < 11) {
        phone += number.substr(0, 3);
        phone += "-";
        phone += number.substr(3, 3);
        phone += "-";
        phone += number.substr(6);
    } else {
        phone += number.substr(0, 3);
        phone += "-";
        phone += number.substr(3, 4);
        phone += "-";
        phone += number.substr(7);
    }
    str = phone;
    return phone;
}

function getTel(str) {
    var number = '';
    var phone = "";
    if (str != null) {
        number = str.replace(/[^0-9]/g, "");
    } else {
        return '';
    }
    var tel = '';
    if (number.substring(0, 2).indexOf('02') == 0) {
        if (number.length < 3) {
            return number;
        } else if (number.length < 6) {
            tel += number.substr(0, 2);
            tel += "-";
            tel += number.substr(2);
        } else if (number.length < 10) {
            tel += number.substr(0, 2);
            tel += "-";
            tel += number.substr(2, 3);
            tel += "-";
            tel += number.substr(5);
        } else {
            tel += number.substr(0, 2);
            tel += "-";
            tel += number.substr(2, 4);
            tel += "-";
            tel += number.substr(6);
        }

        // 서울 지역번호(02)가 아닌경우
    } else {
        if (number.length < 4) {
            return number;
        } else if (number.length < 7) {
            tel += number.substr(0, 3);
            tel += "-";
            tel += number.substr(3);
        } else if (number.length < 11) {
            tel += number.substr(0, 3);
            tel += "-";
            tel += number.substr(3, 3);
            tel += "-";
            tel += number.substr(6);
        } else {
            tel += number.substr(0, 3);
            tel += "-";
            tel += number.substr(3, 4);
            tel += "-";
            tel += number.substr(7);
        }
    }


    return tel;
}

function getComma(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function getParameter(param) {
    var returnValue;
    var url = location.href;
    var parameters = (url.slice(url.indexOf('?') + 1,
        url.length)).split('&');
    for (var i = 0; i < parameters.length; i++) {
        var varName = parameters[i].split('=')[0];
        if (varName.toUpperCase() == param.toUpperCase()) {
            returnValue = parameters[i].split('=')[1];
            return decodeURIComponent(returnValue);
        }
    }
}


function getRole(str) {
    if (str == null) {
        str = '';
    }
    if (str == '01') {
        str = '일반사용자';
    } else if (str == '02') {
        str = '관리자';
    } else if (str == '03') {
        str = '슈퍼 관리자';
    } else {
        str = '일반사용자';
    }
    return str;
}

function getFormatDate(date) {
    var year = date.getFullYear(); // yyyy
    var month = (1 + date.getMonth()); // M
    month = month >= 10 ? month : '0' + month; // month 두자리로 저장
    var day = date.getDate(); // d
    day = day >= 10 ? day : '0' + day; // day 두자리로 저장
    return year + '-' + month + '-' + day;
}

String.prototype.replaceAll = function(org, dest) {
    return this.split(org).join(dest);
}

function getIP(str) {
    if (str == null) {
        str = '';
    }

    str = str.split('.');
    return str;

}

function getTimeForm(str) {
    if (str == null) {
        str = '';
    }
    return str.substring(0, 2) + ':' + str.substring(2, 4)
}

function getTimeList(id) {
    var str = '<select id="' + id + '" name="' + id + '">';
    str += '<option value="0000">00:00</option>';
    str += '<option value="0030">00:30</option>';
    str += '<option value="0100">01:00</option>';
    str += '<option value="0130">01:30</option>';
    str += '<option value="0200">02:00</option>';
    str += '<option value="0230">02:30</option>';
    str += '<option value="0300">03:00</option>';
    str += '<option value="0330">03:30</option>';
    str += '<option value="0400">04:00</option>';
    str += '<option value="0430">04:30</option>';
    str += '<option value="0500">05:00</option>';
    str += '<option value="0530">05:30</option>';
    str += '<option value="0600">06:00</option>';
    str += '<option value="0630">06:30</option>';
    str += '<option value="0700">07:00</option>';
    str += '<option value="0730">07:30</option>';
    str += '<option value="0800">08:00</option>';
    str += '<option value="0830">08:30</option>';
    str += '<option value="0900">09:00</option>';
    str += '<option value="0930">09:30</option>';
    str += '<option value="1000">10:00</option>';
    str += '<option value="1030">10:30</option>';
    str += '<option value="1100">11:00</option>';
    str += '<option value="1130">11:30</option>';
    str += '<option value="1200">12:00</option>';
    str += '<option value="1230">12:30</option>';
    str += '<option value="1300">13:00</option>';
    str += '<option value="1330">13:30</option>';
    str += '<option value="1400">14:00</option>';
    str += '<option value="1430">14:30</option>';
    str += '<option value="1500">15:00</option>';
    str += '<option value="1530">15:30</option>';
    str += '<option value="1600">16:00</option>';
    str += '<option value="1630">16:30</option>';
    str += '<option value="1700">17:00</option>';
    str += '<option value="1730">17:30</option>';
    str += '<option value="1800">18:00</option>';
    str += '<option value="1830">18:30</option>';
    str += '<option value="1900">19:00</option>';
    str += '<option value="1930">19:30</option>';
    str += '<option value="2000">20:00</option>';
    str += '<option value="2030">20:30</option>';
    str += '<option value="2100">21:00</option>';
    str += '<option value="2130">21:30</option>';
    str += '<option value="2200">22:00</option>';
    str += '<option value="2230">22:30</option>';
    str += '<option value="2300">23:00</option>';
    str += '<option value="2330">23:30</option>';
    str += '<option value="2400">24:00</option>';
    str += '</select>';
    return str;
}

function useTimeList(arr) {
    var str = '';
    for (var i in arr) {
        str += '<option value="' + arr[i].start_time + '">' + getTimeForm(arr[i].start_time) + '</option>';
    }
    return str;
}

function get_reserve_status(val) {
    var str = '';
    console.log('val : ' + val);
    //  if(val == '1'){
    //    str += '<option value="1" selected="selected">임시예약</option>';
    //  }else{
    //    str += '<option value="1">임시예약</option>';
    //  }

    if (val == '2') {
        str += '<option value="2" selected="selected">예약</option>';
    } else {
        str += '<option value="2">예약</option>';
    }

    if (val == '3') {
        str += '<option value="3" selected="selected">승인</option>';
    } else {
        str += '<option value="3">승인</option>';
    }
    if (val == '5') {
        str += '<option value="5" selected="selected">반려</option>';
    } else {
        str += '<option value="5">반려</option>';
    }

    if (val == '4') {
        str = '<option value="4" selected="selected">사용자 취소</option>';
    }

    return str;
}
var ip_filter = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/;

/* When the user clicks on the button,
toggle between hiding and showing the dropdown content */
function myFunction() {
    document.getElementById("myDropdown").classList.toggle("show");
}

function dateDiff(_date1, _date2) {
    var diffDate_1 = _date1 instanceof Date ? _date1 : new Date(_date1);
    var diffDate_2 = _date2 instanceof Date ? _date2 : new Date(_date2);

    diffDate_1 = new Date(diffDate_1.getFullYear(), diffDate_1.getMonth() + 1, diffDate_1.getDate());
    diffDate_2 = new Date(diffDate_2.getFullYear(), diffDate_2.getMonth() + 1, diffDate_2.getDate());

    var diff = diffDate_2.getTime() - diffDate_1.getTime();
    diff = Math.ceil(diff / (1000 * 3600 * 24));
    //    diff = (diff / (1000 * 3600 * 24));

    return diff;
}

function timeDiff(start, end) {
    var start_time = new Date(start);
    var end_time = new Date(end);
    var time_diff = (end_time.getTime() - start_time.getTime()) / 1000 / 60;
    return time_diff;
}

function getDatePlusMonth(start, plus) {
    console.log('start : ', start);
    console.log('plus : ', plus);
    var start = new Date(start);
    start.setMonth((start.getMonth()) + plus);
    console.log(start.getFullYear());
    console.log(start.getMonth() + 1);
    console.log(start);
    start = start.getFullYear() + "-" + (start.getMonth() + 1 < 10 ? '0' + (start.getMonth() + 1) : (start.getMonth() + 1)) +
        "-" + (start.getDate() < 10 ? '0' + start.getDate() : start.getDate());
    console.log('return : ', start);
    return start;
    //  var start = new Date(start);
    //  start = start.getFullYear() + "-" + (start.getMonth()+1+plus < 10 ? '0' + (start.getMonth()+1+plus) : (start.getMonth()+1+plus)) + "-" + (start.getDate());
    //  return start;
}

function getDatePlusDay(start, plus) {
    var start = new Date(start);
    start.setDate(start.getDate() + (plus));
    start = start.getFullYear() + "-" + (start.getMonth() + 1 < 10 ? '0' + (start.getMonth() + 1) : (start.getMonth() + 1)) +
        "-" + (start.getDate() < 10 ? '0' + start.getDate() : start.getDate());
    console.log('return : ', start);
    return start;
}

// Close the dropdown menu if the user clicks outside of it
window.onclick = function(event) {
    if (!event.target.matches('.dropbtn')) {

        var dropdowns = document.getElementsByClassName("dropdown-content");
        var i;
        for (i = 0; i < dropdowns.length; i++) {
            var openDropdown = dropdowns[i];
            if (openDropdown.classList.contains('show')) {
                openDropdown.classList.remove('show');
            }
        }
    }
}


function checkFileName(obj) {
    var str = $(obj).val();
    str = str.split('\\').pop().toLowerCase();;
    //1. 확장자명 체크
    var ext = str.split('.').pop().toLowerCase();
    if ($.inArray(ext, ['bmp', 'hwp', 'jpg', 'pdf', 'png', 'xls', 'zip', 'pptx', 'xlsx', 'jpeg', 'doc', 'gif', 'hwp', 'ppt', 'docx', 'txt']) == -1) {
        alert(ext + '파일은 업로드 하실 수 없습니다.');
        $(obj).val('');
        return false;
        //    alert(ext);
    }
    //2. 파일명에 특수문자 체크
    var pattern = /[\{\}\/?,;:|*~`!^\+<>@\#$%&\\\=\'\"]/gi;
    if (pattern.test(str)) {
        //alert("파일명에 허용된 특수문자는 '-', '_', '(', ')', '[', ']', '.' 입니다.");
        alert('파일명에 특수문자를 제거해주세요.');
        $(obj).val('');
        return false;
    }
}

function notice_file_down(notice_id) {
    document.location.href = '/Common/getNoticeFileDownload.do?notice_id=' + notice_id;
}

function meetroom_file_down(resv_id) {
    document.location.href = '/Common/getMeetRoomFileDownload.do?resv_id=' + resv_id;
}

//leftMenu _ gnb
function openNav() {
    document.getElementById("mySidenav").style.display = "block";
    document.getElementById("mySidenav").style.width = "100%";
    document.getElementById("mySidenav_in").style.left = "0";
    document.getElementById("mySidenav_in").style.left = "0";
    document.body.style.overflow = "hidden";
}

function closeNav() {
    document.getElementById("mySidenav").style.display = "none";
    document.getElementById("mySidenav").style.width = "0";
    document.getElementById("mySidenav_in").style.left = "-27rem";
    document.body.style.overflow = "auto";

}
/* sub menu */
var acc = document.getElementsByClassName("sub_menu");
var i;

for (i = 0; i < acc.length; i++) {
    acc[i].addEventListener("click", function() {
        this.classList.toggle("toggle_on");
        var panel = this.nextElementSibling;
        if (panel.style.display === "block") {
            panel.style.display = "none";

        } else {
            panel.style.display = "block";
        }
    });
}

/* popup */
$('[data-popup-open]').bind('click', function() {
    var targeted_popup_class = jQuery(this).attr('data-popup-open');
    $('[data-popup="' + targeted_popup_class + '"]').bPopup();
    //e.preventDefault();
});


//scroll_Back
$(document).scroll(function() {
    var sct = $(window).scrollTop();
    var docH = $(document).height();
    var fH = $("#header").height();
    var position = docH - (sct + fH);


    //2020-10-13 hd 스크롤 이벤트 추가
    if (sct > 100) {
        $('#header').addClass('on');
    } else {
        $('#header').removeClass('on');
    }
});

function checkEmail(myValue) {
    var email = myValue;
    var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
    if (exptext.test(email) == false) {
        //이메일 형식이 알파벳+숫자@알파벳+숫자.알파벳+숫자 형식이 아닐경우            
        //            alert("이메일형식이 올바르지 않습니다.");
        return false;
    };
    return true;
};


//쿠키 생성 함수
function setCookie(cName, cValue, cDay) {
    var expire = new Date();
    expire.setDate(expire.getDate() + cDay);
    cookies = cName + '=' + escape(cValue) + '; path=/ '; // 한글 깨짐을 막기위해 escape(cValue)를 합니다.
    if (typeof cDay != 'undefined') {
        cookies += ';expires=' + expire.toGMTString() + ';';
    }
    document.cookie = cookies;
}



//쿠키 가져오기 함수
function getCookie(cName) {
    cName = cName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cName);
    var cValue = '';
    if (start != -1) {
        start += cName.length;
        var end = cookieData.indexOf(';', start);
        if (end == -1) {
            end = cookieData.length;
        }
        cValue = cookieData.substring(start, end);
    }
    return unescape(cValue);
}

function dedupe(arr) {
    return arr.reduce(function(p, c) {
        var id = [c.user_id].join('|');
        if (p.temp.indexOf(id) == -1) {
            p.out.push(c);
            p.temp.push(id);
        }
        return p;
    }, {
        temp: [],
        out: []
    }).out;
}

function dedupeOrg(arr) {
    return arr.reduce(function(p, c) {
        var id = [c.org_cd].join('|');
        if (p.temp.indexOf(id) == -1) {
            p.out.push(c);
            p.temp.push(id);
        }
        return p;
    }, {
        temp: [],
        out: []
    }).out;
}

function loadJavascript(url, callback, charset) {
    var head = document.getElementsByTagName('head')[0];
    var script = document.createElement('script');
    script.type = 'text/javascript';
    if (charset != null) {
        script.charset = "utf-8";
    }
    var loaded = false;
    script.onreadystatechange = function() {
        if (this.readyState == 'loaded' || this.readyState == 'complete') {
            if (loaded) {
                return;
            }
            loaded = true;
        }
    }
    script.onload = function() {
        getMeetRoomList()
    }
    script.src = url;
    head.appendChild(script);
}

function removejscssfile(filename, filetype) {

    var targetelement = (filetype == "js") ? "script" : (filetype == "css") ? "link" : "none" //determine element type to create nodelist from
    var targetattr = (filetype == "js") ? "src" : (filetype == "css") ? "href" : "none" //determine corresponding attribute to test for
    var allsuspects = document.getElementsByTagName(targetelement)
    for (var i = allsuspects.length; i >= 0; i--) { //search backwards within nodelist for matching elements to remove
        if (allsuspects[i] && allsuspects[i].getAttribute(targetattr) != null && allsuspects[i].getAttribute(targetattr).indexOf(filename) != -1)
            allsuspects[i].parentNode.removeChild(allsuspects[i]) //remove element by calling parentNode.removeChild()
    }
}


function getWeekOfMonth(dateFormat) {
    const inputDate = new Date(dateFormat);

    // 인풋의 년, 월
    let year = inputDate.getFullYear();
    let month = inputDate.getMonth() + 1;

    // 목요일 기준 주차 구하기
    const weekNumberByThurFnc = (paramDate) => {
        const year = paramDate.getFullYear();
        const month = paramDate.getMonth();
        const date = paramDate.getDate();

        // 인풋한 달의 첫 날과 마지막 날의 요일
        const firstDate = new Date(year, month, 1);
        const lastDate = new Date(year, month + 1, 0);
        const firstDayOfWeek = firstDate.getDay() === 0 ? 7 : firstDate.getDay();
        const lastDayOfweek = lastDate.getDay();

        // 인풋한 달의 마지막 일
        const lastDay = lastDate.getDate();

        // 첫 날의 요일이 금, 토, 일요일 이라면 true
        const firstWeekCheck = firstDayOfWeek === 5 || firstDayOfWeek === 6 || firstDayOfWeek === 7;
        // 마지막 날의 요일이 월, 화, 수라면 true
        const lastWeekCheck = lastDayOfweek === 1 || lastDayOfweek === 2 || lastDayOfweek === 3;

        // 해당 달이 총 몇주까지 있는지
        const lastWeekNo = Math.ceil((firstDayOfWeek - 1 + lastDay) / 7);

        // 날짜 기준으로 몇주차 인지
        let weekNo = Math.ceil((firstDayOfWeek - 1 + date) / 7);

        // 인풋한 날짜가 첫 주에 있고 첫 날이 월, 화, 수로 시작한다면 'prev'(전달 마지막 주)
        if (weekNo === 1 && firstWeekCheck) {
            weekNo = 'prev';
        }
        // 인풋한 날짜가 마지막 주에 있고 마지막 날이 월, 화, 수로 끝난다면 'next'(다음달 첫 주)
        else if (weekNo === lastWeekNo && lastWeekCheck) {
            weekNo = 'next';
        }
        // 인풋한 날짜의 첫 주는 아니지만 첫날이 월, 화 수로 시작하면 -1;
        else if (firstWeekCheck) {
            weekNo = weekNo - 1;
        }

        return weekNo;
    };

    // 목요일 기준의 주차
    let weekNo = weekNumberByThurFnc(inputDate);

    // 이전달의 마지막 주차일 떄
    if (weekNo === 'prev') {
        // 이전 달의 마지막날
        const afterDate = new Date(year, month - 1, 0);
        year = month === 1 ? year - 1 : year;
        month = month === 1 ? 12 : month - 1;
        weekNo = weekNumberByThurFnc(afterDate);
    }
    // 다음달의 첫 주차일 때
    if (weekNo === 'next') {
        year = month === 12 ? year + 1 : year;
        month = month === 12 ? 1 : month + 1;
        weekNo = 1;
    }

    return {
        year,
        month,
        weekNo
    };
}

function getKioskRoomDate(date) {
    var r_date = date.substring(4, 6) + '.' + date.substring(6, 8);
    var week = getWeek(getDateForm(date));
    return r_date + ' ' + week;
}

function getWeek(str) {
    var day = new Date(str);
    var week = new Array('일', '월', '화', '수', '목', '금', '토');
    var str = week[day.getDay()];
    return str;
}

function getReserveDateForm(date, val) {
    var r_date = date.substring(5, 7) + '.' + date.substring(8, 10);
    var week = getWeek(date);
    if (getStr(val) == '') {
        return r_date;
    } else {
        return r_date + ' (' + week + ') ';
    }
}

function getReserveDateForm2(date, val) {
    var r_date = date.substring(5, 7) + '.' + date.substring(8, 10);
    var week = getWeek(date.substring(0, 10));
    if (getStr(val) == '') {
        return r_date;
    } else {
        return r_date + ' (' + week + ') ';
    }
}

function getReserveFullTime(str) {
    var hours = Math.floor(str / 60);
    var minutes = str % 60;
    if (minutes == 0) {
        str = hours + '시간을'
    } else {
        str = hours + '시간 ' + minutes + '분을'
    }
    return str;
}

function getReserveFullTimeKiosk(str) {
    var hours = Math.floor(str / 60);
    var minutes = str % 60;
    if (minutes == 0) {
        str = hours + '시간'
    } else {
        str = hours + '시간 ' + minutes + '분'
    }
    return str;
}


/* 화면블럭 */
$.blockGlobal = function() {
    var loading = '&nbsp;';
    loading += '<div class="circle"></div>';

    $.blockUI({
        message: loading,
        fadeIn: 1,
        fadeOut: 5,
        baseZ: 9999,
        css: {
            backgroundColor: 'none',
            border: 'none',
            width: '50px',
            left: '45%',
        },
    });
};


/* 로그인 탭메뉴 */
var tabBtn = $("#tab_btn > ul > li"); //각각의 버튼을 변수에 저장
/*var tabCont = $("#tab_cont > div"); //각각의 콘텐츠를 변수에 저장

//컨텐츠 내용을 숨겨주세요!
tabCont.hide().eq(0).show();*/

tabBtn.click(function() {
    var target = $(this); //버튼의 타겟(순서)을 변수에 저장
    tabBtn.addClass("active"); //타겟의 클래스를 추가
    target.removeClass("active"); //버튼의 클래스를 삭제
    
/*    tabCont.css("display", "none");
    tabCont.eq(index).css("display", "block");*/
});