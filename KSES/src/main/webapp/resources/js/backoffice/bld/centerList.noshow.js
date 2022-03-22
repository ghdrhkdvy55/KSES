$.Noshow = function() {
    this._editoptions = {
        size: 5,
        maxlength: 5
    };
};

$.Noshow.prototype.mainGridSettings = function() {
    MainGridAjaxUrl = '/backoffice/bld/noshowInfoListAjax.do';
    EgovJqGridApi.mainGrid([
        { label: '노쇼코드', name: 'noshow_cd', key: true, hidden:true },
        { label: '요일', name: 'noshow_day_text', align: 'center', sortable: false },
        { label: '1차자동취소시간', name: 'noshow_pm_tm', align: 'center', sortable: false, editable: true, editoptions: this._editoptions },
        { label: '2차자동취소시간', name: 'noshow_all_tm', align: 'center', sortable: false, editable: true, editoptions: this._editoptions },
    ], false, false, fnSearch, false).jqGrid('setGridParam', {
        cellEdit: true,
        cellsubmit: 'clientArray'
    });
    $('#rightAreaUqBtn').html(
        '<a href="javascript:void(0);" class="orangeBtn">복사</a>'
    ).show();
    $('#rightAreaBtn').show();
};

$.Noshow.prototype.updateSettings = function(ajaxUpdate, changedArr) {
    ajaxUpdate.title = '자동취소 수정';
    ajaxUpdate.url = '/backoffice/bld/noshowInfoUpdate.do';
    changedArr.forEach(x => ajaxUpdate.params.push({
        noshowCd: x.noshow_cd,
        noshowPmTm: x.noshow_pm_tm.replace(/\:/g,''),
        noshowAllTm: x.noshow_all_tm.replace(/\:/g,'')
    }));
};

$.Noshow.prototype.centerCopy = function(ajaxCopy) {
    ajaxCopy.title = '자동취소시간 복사';
    ajaxCopy.url = '/backoffice/bld/noshowInfoCopy.do';
};

const Noshow = new $.Noshow();