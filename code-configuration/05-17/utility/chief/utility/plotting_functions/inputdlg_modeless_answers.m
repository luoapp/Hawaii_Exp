function Answer=inputdlg_modeless_answers(FigInfo,Timeout)
if nargin<2
    Timeout=1E8;
end
while Timeout>0
    TempHide=get(0,'ShowHiddenHandles');
    set(0,'ShowHiddenHandles','on');
    
    if any(get(0,'Children')==FigInfo.InputFig),
        Answer={};
        ud=get(FigInfo.InputFig,'UserData');
        if ~ischar(ud)
            Timeout=Timeout-.25;
            pause(.25);
            continue
        end
        if strcmp(ud,'OK'),
            Answer=cell(FigInfo.NumQuest,1);
            for lp=1:FigInfo.NumQuest,
                Answer(lp)=get(FigInfo.EditHandle(lp),{'String'});
            end % for
        end % if strcmp
        delete(FigInfo.InputFig);
        return
    else,
        Answer={};
    end % if any
    
    set(0,'ShowHiddenHandles',TempHide);
    Timeout=Timeout-.25
    pause(.25);
end
if Timeout<=0
    delete(FigInfo.InputFig);
end    
