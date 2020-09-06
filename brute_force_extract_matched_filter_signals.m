function brute_force_extract_matched_filter_signals(Dir,params)
dtyp=get_signal_start_times;
for i=1:length(dtyp)
    disp(sprintf('%d %s',i,dtyp{i}));
end
if exist('params','var')
    it=params{1};
else
    it=input_with_default('enter number of band to get',1);
end
seltype=dtyp{it};
seltype_file=seltype;ix=find(seltype_file==' ');
seltype_file(ix)='_';
SR=40323.58065;
switch seltype
    case 'udel lowband'
        S=load('hfx_signals_low_rcv');
        sigs={S.Ss{1},S.Ss{2},S.Ss{3},S.Ss{4},S.Ss{5},S.Ss{6},S.Ss{7}};
        signames={'qCW1','qCW2','qCW3','40msec','80msec','160msec','320msec'};
        sigoffset=[0,cumsum(sum(round([[S.T{1}(2:end)];[S.Delay{1}(1:end-1)]]*SR)))];
        sigtosigoffset=round(sum(sum([S.T{1};S.Delay{1}]*SR))+.5*SR);
    case 'udel midband'
        S=load('hfx_signals_mid_rcv');
        sigs={S.Ss{1},S.Ss{2},S.Ss{3},S.Ss{4},S.Ss{5},S.Ss{6},S.Ss{7}};
        signames={'qCW1','qCW2','qCW3','40msec','80msec','160msec','320msec'};
        sigoffset=[0,cumsum(sum(round([[S.T{1}(2:end)];[S.Delay{1}(1:end-1)]]*SR)))];
        sigtosigoffset=sum(sum([S.T{1};S.Delay{1}]*SR))+round(.5*SR);
    case 'udel highband'
        S=load('hfx_signals_high_rcv');
        sigs={S.Ss{1},S.Ss{2},S.Ss{3},S.Ss{4},S.Ss{5},S.Ss{6},S.Ss{7}};
        signames={'qCW1','qCW2','qCW3','40msec','80msec','160msec','320msec'};
        sigoffset=[0,cumsum(sum(round([[S.T{1}(2:end)];[S.Delay{1}(1:end-1)]]*SR)))];
        sigtosigoffset=sum(sum([S.T{1};S.Delay{1}]*SR))+round(.5*SR);
    otherwise
        error(sprintf('invalid signal type %s',seltype));
end
for i=1:length(signames)
    disp(sprintf('%d %s',i,signames{i}));
end
if exist('params','var')
    isig=params{2};
else
    isig=input_with_default('enter signal type to get',1);
end
Fcen=mean(S.F{it}(isig,:));
if exist('params','var')
    drspec=params{3};
else
    drspec=input_with_default('enter file specs to read, with no extension (e.g., 20030701T03*)','*');
end
if exist('params','var')
    dirspec=params{4};
else
    dirspec=input_with_default('enter input directory (no trailing slash)',Dir);
end
dr=dir(sprintf('%s\\*.daq',dirspec));
[b,a] = butter(8,1000/SR*2);
tic
figure
for i1=1:length(dr)
    drawnow
    [toks,tokf,tokt]=regexpi(dr(i1).name,[drspec,'.daq']);
    if length(toks)==0
        continue
    end
    idir=sprintf('%s\\',dirspec);
    toc,tic
    disp(dr(i1).name);
    try
        warning off
        [d,sampnums,SR,st,et]=get_raw_daq_data(idir,dr(i1).name,[],1,0,240);
        warning on
    catch
        disp(sprintf('error - file could not be read'));
        continue
    end
    Data={};
    c1=fftfilt(flipud(sigs{isig}),d);
    c=abs(c1);
    c=filter(b,a,c);
    [cmax,id1]=max(c);
    mm=median(c)/cmax;
    plot(c(1:10:end)/cmax);
    drawnow
    pause(.5)
    if mm>.25
        disp(sprintf('failed ratio test, mm=%g',mm));
        continue
    end
    disp(sprintf('spread, mm=%g',mm));
    ix=1:max(1,id1-floor(SR*30));
    c(ix)=0;
    ix=min(length(c),id1+floor(SR*30)):length(c);
    c(ix)=0;
    id=c>(mm*1.0)*cmax;id=find(id);
    if id(1)==1
        id(1)=2;
    end
    if id(end)==length(c)
        id(end)=length(c)-1;
    end
    ix=find(c(id)>=c(id-1)&c(id)>=c(id+1));
    id=id(ix);
    [am,ix]=sort(c(id));
    am=flipud(am);
    ix=id(flipud(ix));
    IX=[];
    id=[];
    for i=1:min(400,length(ix))
        if ismember(ix(i),IX)
            continue
        end
        ix1=ix(i)+[-300:-1,1:300];
        c(ix1)=0;
        IX=unique([IX,ix1,ix(i)]);
        id=[id,ix(i)];
    end
    am1=c(id);
    [am1,id1]=sort(-am1);
    id=id(id1(1:9)); %only 9 pulses
    id=sort(id);
    delix=id(2:end)-id(1:end-1);
    med=median(delix);
    if sum(abs(delix-129834)<SR/10)==0
        disp('did not pass spread test')
        continue
    end
    ix1=find(abs(delix-129834)<SR/100);
    uix1=unique([ix1,ix1+1]);
    id=id(uix1);
    disp('saving data')
    try
        load summary_stat
        FileData=[FileData,{dr(i1).name it isig SR sampnums id c(id) sigoffset sigtosigoffset mm}];
        save summary_stat FileData
    catch
        FileData={dr(i1).name it isig SR sampnums id c(id) sigoffset sigtosigoffset mm};
        save summary_stat FileData
    end
end