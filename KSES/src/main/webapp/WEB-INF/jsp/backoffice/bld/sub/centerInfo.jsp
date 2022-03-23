<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="pop_con">
    <a class="button b-close">X</a>
    <h2 class="pop_tit"></h2>
    <div class="pop_wrap">
        <form>
            <input type="hidden" name="mode" value="Ins">
            <table class="detail_table">
                <tbody>
                <tr>
                    <th>지점명</th>
                    <td>
                        <input type="hidden" name="centerCd">
                        <input type="text" name="centerNm">
                    </td>
                    <th>주소</th>
                    <td>
                        <input type="text" name="centerAddr1" style="width:200px;margin-right:5px;">
                        <input type="text" name="centerAddr2" style="width:200px;margin-right:5px;">
                    </td>
                </tr>
                <tr>
                    <th>대표번호</th>
                    <td><input type="text" name="centerTel" maxlength="15"></td>
                    <th>Fax</th>
                    <td><input type="text" name="centerFax" maxlength="15"></td>
                </tr>
                <tr>
                    <th>전경 사진</th>
                    <td><input type="file" name="centerImgFile"></td>
                    <th>내부 이미지</th>
                    <td><input type="file" name="centerMapFile"></td>
                </tr>
                <tr>
                    <th>전체 사용 층</th>
                    <td>
                        <select name="startFloor">
                            <option value="">시작 층수</option>
                            <c:forEach items="${floorInfo}" var="floor">
                                <option value="${floor.code}"><c:out value='${floor.codenm}'/></option>
                            </c:forEach>
                        </select> ~
                        <select name="endFloor">
                            <option value="">종료 층수</option>
                            <c:forEach items="${floorInfo}" var="floor">
                                <option value="${floor.code}"><c:out value='${floor.codenm}'/></option>
                            </c:forEach>
                        </select>
                    </td>
                    <th>정렬 순서</th>
                    <td><input type="text" name="centerOrder" numberonly></td>
                </tr>
                <tr>
                    <th>사용 여부</th>
                    <td>
                        <input type="radio" name="useYn" value="Y">사용</input>
                        <input type="radio" name="useYn" value="N">사용 안함</input>
                    </td>
					<th>시범 지점 여부</th>
                    <td>
                        <input type="radio" name="centerPilotYn" value="Y">사용</input>
                        <input type="radio" name="centerPilotYn" value="N">사용 안함</input>
                    </td>
                </tr>
                <tr>
                    <th>자유석 사용 여부</th>
                    <td>
                        <input type="radio" name="centerStandYn" value="Y">사용</input>
                        <input type="radio" name="centerStandYn" value="N">사용 안함</input>
                    </td>
					<th>최대 자유석수</th>
                    <td><input type="text" name="centerStandMax" numberonly></td>
                </tr>
                <tr>
                    <th>지점 입장료</th>
                    <td><input type="text" name="centerEntryPayCost" numberonly></td>
					<th>지점 입장료(스피드온)</th>
                    <td><input type="text" name="centerSpeedEntryPayCost" numberonly></td>
                </tr>
                <tr>
                    <th>SPEEDON CODE</th>
                    <td><input type="text" name="centerSpeedCd" maxlength="15"></td>
                    <th>RBM CODE</th>
                    <td><input type="text" name="centerRbmCd" maxlength="2"></td>
                </tr>
                <tr>
                    <th>지점 사전예약일</th>
                    <td>
						<select name="centerResvAbleDay">
							<c:forEach items="${centerResvAbleDay}" var="centerResvAbleDay">
								<option value="${centerResvAbleDay.codenm}"><c:out value='${centerResvAbleDay.codenm}'/>일</option>
							</c:forEach>
                        </select>
                    </td>
                    <th></th>
                    <td></td>
                </tr>
                </tbody>
            </table>
        </form>
    </div>
    <popup-right-button clickFunc="CenterInfo.save();" />
</div>
<script type="text/javascript">
    $.CenterInfo = function() {
        EgovIndexApi.numberOnly();
    };

    $.CenterInfo.prototype.getPopup = function() {
        return $('[data-popup=bld_centerinfo_add]');
    };

    $.CenterInfo.prototype.bPopup = function(centerCd, centerNm) {
        let $popup = this.getPopup();
        let $form = $popup.find('form:first');
        if (centerCd === undefined || centerCd === null) {
            $popup.find('h2.2:first').text('지점 등록');
            $form.find(':hidden[name=mode]').val('Ins');
            $form.find(':text').val('');
            $form.find(':text[name=centerTel]').val('02-3422-0000');
            $form.find(':text[name=centerFax]').val('02-3422-0001');
            $form.find(':text[name=centerOrder]').val(0);
            $form.find(':text[name=centerStandMax]').val(0);
            $form.find(':text[name=centerEntryPayCost]').val(0);
            $form.find(':text[name=centerSpeedEntryPayCost]').val(0);
            $form.find('select[name=centerResvAbleDay] option:first').prop('selected', true);
            $form.find('select[name=startFloor] option:first').prop('selected', true);
            $form.find('select[name=endFloor] option:first').prop('selected', true);
            $form.find(':radio[name=useYn]:first').prop('checked', true);
            $form.find(':radio[name=centerPilotYn]:first').prop('checked', true);
            $form.find(':radio[name=centerStandYn]:first').prop('checked', true);
        } else {
            EgovIndexApi.apiExecuteJson(
                'GET',
                '/backoffice/bld/centerInfoDetail.do', {
                    centerCd: centerCd
                },
                function(xhr) {
                    $popup.find('h2:first').text(centerNm +' 지점 수정');
                    EgovJqGridApi.selection('centerGrid', centerCd);
                },
                function(json) {
                    let data = json.result;
                    $form.find(':hidden[name=mode]').val('Edt');
                    $form.find(':file').val('');
                    $form.find(':hidden[name=centerCd]').val(data.center_cd);
                    $form.find(':text[name=centerNm]').val(data.center_nm);
                    $form.find(':text[name=centerAddr1]').val(data.center_addr1);
                    $form.find(':text[name=centerAddr2]').val(data.center_addr2);
                    $form.find(':text[name=centerTel]').val(data.center_tel);
                    $form.find(':text[name=centerFax]').val(data.center_fax);
                    $form.find('select[name=startFloor]').val(data.start_floor);
                    $form.find('select[name=endFloor]').val(data.end_floor);
                    $form.find(':text[name=centerOrder]').val(data.center_order);
                    $form.find(':text[name=centerUrl]').val(data.center_url);
                    $form.find(':radio[name=useYn][value='+ data.use_yn +']').prop('checked', true);
                    $form.find(':radio[name=centerPilotYn][value='+ data.center_pilot_yn +']').prop('checked', true);
                    $form.find(':radio[name=centerStandYn][value='+ data.center_stand_yn +']').prop('checked', true);
                    $form.find(':text[name=centerStandMax]').val(data.center_stand_max);
                    $form.find(':text[name=centerEntryPayCost]').val(data.center_entry_pay_cost);
                    $form.find(':text[name=centerSpeedEntryPayCost]').val(data.center_speed_entry_pay_cost);
                    $form.find('select[name=centerResvAbleDay]').val(data.center_resv_able_day);
                    $form.find(':text[name=centerSpeedCd]').val(data.center_speed_cd);
                    $form.find(':text[name=centerRbmCd]').val(data.center_rbm_cd);
                },
                function(json) {
                    toastr.warning(json.message);
                }
            );
        }
        $popup.bPopup();
    };

    $.CenterInfo.prototype.save = function() {
        let $popup = this.getPopup();
        if ($popup.find(':text[name=centerNm]').val() === '') {
            toastr.warning('지점명을 입력해 주세요.');
            return;
        }
        let formData = new FormData($popup.find('form:first')[0]);
        if ($popup.find('select[name=startFloor]').val() !== '' && $popup.find('select[name=endFloor]').val()) {
            let startFloor = $popup.find('select[name=startFloor]').val().replace('CENTER_FLOOR_','');
            let endFloor = $popup.find('select[name=endFloor]').val().replace('CENTER_FLOOR_','');
            if (parseInt(startFloor) > parseInt(endFloor)) {
                toastr.warning('시작 층수가 종료 층수보다 큽니다.');
                return;
            }
            let floorInfo = new Array();
            for (let i = startFloor; i<=endFloor; i++) {
                floorInfo.push(i);
            }
            formData.append('floorInfo', floorInfo.join(','));
        }
        bPopupConfirm('지점 '+ ($popup.find(':hidden[name=mode]').val() === 'Ins' ? '등록' : '수정'), '저장 하시겠습니까?', function() {
            EgovIndexApi.apiExcuteMultipart(
                '/backoffice/bld/centerInfoUpdate.do',
                formData,
                null,
                function(json) {
                    toastr.success(json.message);
                    $popup.bPopup().close();
                    fnCenterSearch(1);
                },
                function(json) {
                    toastr.error(json.message);
                }
            );
        });
    };

    const CenterInfo = new $.CenterInfo();
</script>